require "colorize"
require "rouge"
require "ruby-anthropic"

module ClaudeCourse
  class NotebookRunner
    attr_reader :client, :results

    def initialize
      @client = Anthropic::Client.new(access_token: ENV["ANTHROPIC_API_KEY"])
      @results = []
      @cell_count = 0
    end

    def run_cell(code, description = nil)
      @cell_count += 1
      
      puts "\n#{'═' * 60}".cyan
      puts "Cell [#{@cell_count}]:".bold.green
      puts description.yellow if description
      puts "#{'─' * 60}".cyan
      
      # Syntax highlighting do código
      formatter = Rouge::Formatters::Terminal256.new
      lexer = Rouge::Lexers::Ruby.new
      highlighted_code = formatter.format(lexer.lex(code))
      puts highlighted_code
      
      puts "\n#{'Output:'.bold}".magenta
      puts "#{'─' * 60}".cyan
      
      begin
        # Captura stdout temporariamente
        original_stdout = $stdout
        captured_output = StringIO.new
        $stdout = captured_output
        
        # Executa o código
        result = eval(code, binding)
        
        # Restaura stdout
        $stdout = original_stdout
        
        # Mostra output capturado
        output = captured_output.string
        puts output unless output.empty?
        
        # Mostra resultado
        if result
          puts "=> #{result.inspect}".green
        end
        
        @results << {
          cell: @cell_count,
          code: code,
          output: output,
          result: result
        }
        
        result
      rescue StandardError => e
        $stdout = original_stdout if $stdout != original_stdout
        puts "Error: #{e.message}".red
        puts e.backtrace.first(3).join("\n").light_red
        nil
      end
    end

    def markdown(text)
      puts "\n#{text}".light_white
    end

    def section(title)
      puts "\n#{'╔' + '═' * (title.length + 4) + '╗'}".bold.cyan
      puts "#{'║'}  #{title.bold.white}  #{'║'}".bold.cyan
      puts "#{'╚' + '═' * (title.length + 4) + '╝'}".bold.cyan
    end

    def save_session(filename)
      File.write(
        "lib/claude_course/notebooks/#{filename}.json",
        JSON.pretty_generate(@results)
      )
      puts "\nSession saved to: lib/claude_course/notebooks/#{filename}.json".green
    end

    def clear
      @results = []
      @cell_count = 0
      system("clear") || system("cls")
    end

    # Atalho para fazer chamadas à API Claude
    def ask_claude(prompt, model: ENV["CLAUDE_MODEL"] || "claude-3-5-sonnet-20241022", max_tokens: ENV["CLAUDE_MAX_TOKENS"]&.to_i || 1024)
      response = @client.messages(
        parameters: {
          model: model,
          messages: [{ role: "user", content: prompt }],
          max_tokens: max_tokens
        }
      )
      
      response.dig("content", 0, "text")
    rescue StandardError => e
      "Erro ao chamar API: #{e.message}"
    end

    # Helper para formatar respostas da Claude
    def display_claude_response(response)
      puts "\n#{'Claude says:'.bold.blue}"
      puts "#{'─' * 60}".cyan
      puts response.light_white
      puts "#{'─' * 60}".cyan
    end
  end
end