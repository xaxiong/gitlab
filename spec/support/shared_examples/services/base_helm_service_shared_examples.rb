# frozen_string_literal: true

shared_examples 'logs kubernetes errors' do
  let(:error_hash) do
    {
      exception: error_name,
      message: error_message,
      backtrace: instance_of(Array),
      service: service.class.name,
      app_id: application.id,
      project_ids: application.cluster.project_ids,
      group_ids: [],
      error_code: error_code
    }
  end

  it 'logs into kubernetes.log and Sentry' do
    expect(service.send(:logger)).to receive(:error).with(error_hash)

    expect(Gitlab::Sentry).to receive(:track_acceptable_exception).with(
      error,
      extra: hash_including(error_hash)
    )

    service.execute
  end
end
