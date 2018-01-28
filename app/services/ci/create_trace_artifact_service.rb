module Ci
  class CreateTraceArtifactService < BaseService
    def execute(job)
      return if job.job_artifacts_trace

      job.trace.read do |stream|
        job.create_job_artifacts_trace!(
          project: job.project,
          file_type: :trace,
          file: stream) if stream.file?
      end
    end
  end
end
