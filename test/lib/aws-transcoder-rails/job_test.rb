require 'test_helper'

module AwsTranscoderRails
  class JobTest < ActiveSupport::TestCase
    setup do
      @file = file_fixture('trailer_1080p.mp4')
    end

    test 'should job create' do
      binding.pry
      client = AwsTranscoderRails::Transcoder::Job.create(@file)
      assert true
    end
  end
end
