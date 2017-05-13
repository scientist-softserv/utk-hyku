RSpec.describe ActiveJobTenant do
  before do
    allow(Apartment::Tenant).to receive(:current).and_return('x')
    allow(Account).to receive(:find_by).with(tenant: 'x').and_return(account)
    allow(Apartment::Tenant).to receive(:switch).with('x') do |&block|
      block.call
    end
  end

  let(:account) { FactoryGirl.build(:account, tenant: 'x') }

  subject do
    Class.new(Hyrax::ApplicationJob) do
      def perform
        current_account
      end
    end
  end

  describe 'tenant context' do
    it 'switches to the tenant database' do
      expect(Apartment::Tenant).to receive(:switch).with('x')

      subject.perform_now
    end

    it 'evaluates in the context of a tenant and account' do
      expect(subject.perform_now).to eq account
    end
  end

  # mimics the `.perform_later` workflow
  describe '.deserialize' do
    let(:serialized_job) { subject.new.serialize.merge('job_class' => 'Hyrax::ApplicationJob') }
    let(:delayed_subject) { subject.deserialize(serialized_job) }

    it 'preserves the original tenant' do
      expect(delayed_subject.tenant).to eq 'x'
    end
  end
end
