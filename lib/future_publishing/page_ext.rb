FuturePublishing::PageExt = Proc.new do
  def published?
    status == Status[:published] && published_at <= Time.current
  end
end