# frozen_string_literal: true

require 'spec_helper'

RSpec.describe GoodJob do
  subject { GoodJob::Configuration.new({}) }

  it 'does not clean up discarded jobs' do
    expect(subject).not_to be_cleanup_discarded_jobs
  end

  it 'preserves job records' do
    expect(GoodJob.preserve_job_records).to be_truthy
  end

  it 'will cleanup old preserved AND successful jobs' do
    expect(subject.cleanup_preserved_jobs_before_seconds_ago).to be_a(Integer)
  end

  it 'will run the clean-up every day (or so)' do
    expect(subject.cleanup_interval_seconds).to be_a(Integer)
  end
end
