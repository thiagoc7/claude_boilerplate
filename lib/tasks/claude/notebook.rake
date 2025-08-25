namespace :claude do
  desc "Run a Claude Course notebook file"
  task notebook: :environment do
    require_relative "../../claude_course/notebook_runner"
    
    notebook_file = ENV["FILE"] || ENV["file"]
    
    if notebook_file.nil?
      puts "Usage: rails claude:notebook FILE=path/to/notebook.rb"
      puts "\nAvailable notebooks:"
      Dir["lib/claude_course/**/*.rb"].each do |file|
        next if file.include?("notebook_runner")
        puts "  - #{file}"
      end
      exit
    end
    
    unless File.exist?(notebook_file)
      puts "File not found: #{notebook_file}"
      exit 1
    end
    
    puts "\n🚀 Starting Claude Notebook Runner...".bold.green
    puts "=" * 60
    
    # Cria instância do runner disponível no contexto do notebook
    $notebook = ClaudeCourse::NotebookRunner.new
    
    # Helpers globais para facilitar uso
    def cell(code, description = nil)
      $notebook.run_cell(code, description)
    end
    
    def markdown(text)
      $notebook.markdown(text)
    end
    
    def section(title)
      $notebook.section(title)
    end
    
    def ask_claude(prompt, **options)
      $notebook.ask_claude(prompt, **options)
    end
    
    def display_claude(response)
      $notebook.display_claude_response(response)
    end
    
    # Executa o notebook
    load notebook_file
    
    puts "\n✅ Notebook completed!".bold.green
  end
  
  desc "Start interactive Claude console (Rails console with Claude helpers)"
  task console: :environment do
    require_relative "../../claude_course/notebook_runner"
    
    puts "\n🎮 Starting Interactive Claude Console...".bold.cyan
    puts "=" * 60
    puts "Available commands:".yellow
    puts "  notebook = ClaudeCourse::NotebookRunner.new  # Create notebook instance"
    puts "  notebook.run_cell(code, description)         # Run Ruby code"
    puts "  notebook.ask_claude(prompt)                  # Ask Claude"
    puts "  notebook.section(title)                      # Add section"
    puts "  notebook.markdown(text)                      # Add markdown"
    puts "  notebook.save_session(filename)              # Save session"
    puts "=" * 60
    
    # Inicia o console Rails com o notebook pré-carregado
    exec "rails console"
  end
end