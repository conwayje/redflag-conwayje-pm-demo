class OverdueTaskStatusUpdateJob
  include Sidekiq::Job

  def perform(*args)
    Task.where("due_date < ?", Time.now).update_all(status: "late")
  end
end
