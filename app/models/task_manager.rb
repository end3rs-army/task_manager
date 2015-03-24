require 'yaml/store'
require_relative 'task'

class TaskManager
  def self.database
    @database ||= YAML::Store.new("db/task_manager")
  end

  def self.create(task)
    database.transaction do
      database['tasks'] ||= []
      database['total'] ||= 0
      database['total'] += 1
      database['tasks'] << { "id" => database['total'], "title" => task[:title], "description" => task[:description] }
    end
    reorder
  end

  def self.raw_tasks
    database.transaction do 
      database['tasks'] || []
    end
  end

  def self.all
    raw_tasks.map { |data| Task.new(data) }
  end

  def self.raw_task(id)
    raw_tasks.find { |task| task["id"] == id }
  end

  def self.find(id)
    Task.new(raw_task(id.to_i))
  end

  def self.delete(id)
    database.transaction do 
      database['tasks'].delete_at(id.to_i - 1)
    end
    reorder
  end

  def self.reorder
    database.transaction do
      database['tasks'].each_with_index { |task, index| task["id"] = index + 1 }
    end
  end

  def self.update(id, task)
    database.transaction do
      database['tasks'][id.to_i - 1] = task 
    end
    reorder
  end

end