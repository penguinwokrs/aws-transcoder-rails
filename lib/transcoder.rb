# frozen_string_literal: true

require 'transcoder/config'
require 'transcoder/preset'
require 'aws-sdk-elastictranscoder'

module Transcoder
  class << self
    attr_writer :outputs

    def create_preset(input_key)
      use_preset.map do |input_preset|
        preset = const_get(input_preset)
        preset.merge(key: "#{preset[:key]}#{output_key(input_key)}", segment_duration: segment_duration)
      end
    end

    def create_playlist(input_key)
      {
        name: 'hls_' + output_key(input_key),
        format: 'HLSv3',
        output_keys: create_preset(input_key).map { |output| output[:key] }
      }
    end

    def create_job(input_key)
      transcoder_client = Aws::ElasticTranscoder::Client.new(
        region: region,
        access_key_id: access_key,
        secret_access_key: secret_key
      )

      input = { key: input_key }

      transcoder_client.create_job(
        pipeline_id: pipeline_id,
        input: input,
        output_key_prefix: output_key_prefix + output_key(input_key) + '/',
        outputs: create_preset(input_key),
        playlists: [create_playlist(input_key)]
      )[:job]
    end
  end
  self.outputs = []
end