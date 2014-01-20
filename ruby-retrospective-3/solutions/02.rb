class Todo
  attr_accessor :status, :description, :priority, :tags

  def initialize(state, descr, prior, tag)
    @status = state
    @description = descr
    @priority = prior
    @tags = tag
  end

  def to_a
    [@status] + [@description] + [@priority] + [@tags]
  end
end

DECODE = {'TODO' => :todo, 'CURRENT' => :current, 'DONE' => :done,
          'High' => :high, 'Normal' => :normal, 'Low' => :low}

class TodoList
  include Enumerable
  attr_accessor :tasks

  def self.parse(text)
    new_todo, new_todo.tasks = TodoList.new , []
    new_todo.format_text(text).each do |x|
      new_todo.tasks.push(Todo.new(x[0], x[1], x[2], x[3].split(', ')))
    end
    new_todo
  end

  def each
    current = 0
    while current < @tasks.size
      yield @tasks[current]
      current += 1
    end
  end

  def format_text(text)
    todos = text.each_line.to_a.map { |x| x.split("|",4) }
    todos.each do |x|
      x[0], x[1] = DECODE[x[0].strip], x[1].strip
      x[2] , x[3] = DECODE[x[2].strip], x[3].strip
    end
  end

  def filter(criteria)
    new_todo, new_todo.tasks = TodoList.new , @tasks
    new_todo.tasks = @tasks.select {|x| Criteria.pass? x.to_a, criteria.to_a}
    new_todo
  end

  def adjoin(todo_list)
    new_todo, new_todo.tasks = TodoList.new , @tasks
    todo_list.tasks.each { |x| new_todo.tasks.push(x)}
    new_todo
  end

  def tasks_todo
    self.select { |x| x.status == :todo}.size
  end

  def tasks_in_progress
    self.select { |x| x.status == :current}.size
  end

  def tasks_completed
    self.select { |x| x.status == :done}.size
  end
end

class TodoCriteria
  attr_accessor :states, :priorities, :tags

  def initialize(state, prior, tag)
    @states = state
    @priorities = prior
    @tags = tag
  end

  def to_a
    [@states] + [@priorities] + [@tags]
  end

end

class Criteria
  class << self
    def status(state)
      TodoCriteria.new state, nil, nil
    end

    def priority(priorty_type)
      TodoCriteria.new nil, priorty_type, nil
    end

    def tags(tag)
      TodoCriteria.new nil, nil, tag
    end
    def pass?(todo, crit)
      value = true
      value = crit[0] == todo[0] unless crit[0] == nil
      value = crit[1] == todo[1] unless crit[1] == nil
      value = (todo[3] & crit[2]).size == crit[2].size unless crit[2] == nil
    end
  end
end