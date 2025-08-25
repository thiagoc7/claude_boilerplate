module Claude
  class ClientService
    attr_reader :client

    def initialize(api_key: nil)
      @client = Anthropic::Client.new(
        access_token: api_key || ENV["ANTHROPIC_API_KEY"]
      )
    end

    def chat(message, model: nil, max_tokens: nil, temperature: nil, system: nil)
      parameters = {
        model: model || ENV["CLAUDE_MODEL"] || "claude-3-5-sonnet-20241022",
        messages: format_messages(message),
        max_tokens: max_tokens || ENV["CLAUDE_MAX_TOKENS"]&.to_i || 1024
      }

      parameters[:temperature] = temperature if temperature
      parameters[:system] = system if system

      response = @client.messages(parameters: parameters)
      
      {
        content: response.dig("content", 0, "text"),
        model: response["model"],
        usage: response["usage"],
        stop_reason: response["stop_reason"]
      }
    rescue StandardError => e
      {
        error: e.message,
        content: nil
      }
    end

    def stream_chat(message, model: nil, max_tokens: nil, temperature: nil, system: nil, &block)
      parameters = {
        model: model || ENV["CLAUDE_MODEL"] || "claude-3-5-sonnet-20241022",
        messages: format_messages(message),
        max_tokens: max_tokens || ENV["CLAUDE_MAX_TOKENS"]&.to_i || 1024,
        stream: true
      }

      parameters[:temperature] = temperature if temperature
      parameters[:system] = system if system

      @client.messages(parameters: parameters) do |event|
        yield event if block_given?
      end
    end

    private

    def format_messages(input)
      case input
      when String
        [{ role: "user", content: input }]
      when Array
        input
      when Hash
        [input]
      else
        raise ArgumentError, "Invalid message format"
      end
    end
  end
end