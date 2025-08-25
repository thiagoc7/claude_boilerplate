# Lesson 01: Hello Claude - Primeira Interação com a API
# Este notebook demonstra como fazer sua primeira chamada à API da Claude

section "Configuração Inicial"

markdown <<~MD
  Vamos começar verificando se tudo está configurado corretamente.
  Certifique-se de ter sua API key no arquivo .env
MD

cell <<~RUBY, "Verificando configuração"
  api_key_configured = ENV["ANTHROPIC_API_KEY"] && ENV["ANTHROPIC_API_KEY"] != "your_api_key_here"
  
  if api_key_configured
    puts "✅ API Key configurada!"
    puts "Primeiros caracteres: #{ENV['ANTHROPIC_API_KEY'][0..7]}..."
  else
    puts "❌ Configure sua API key no arquivo .env"
    puts "Obtenha sua key em: https://console.anthropic.com/settings/keys"
  end
RUBY

section "Primeira Chamada à API"

markdown <<~MD
  Agora vamos fazer nossa primeira chamada à API da Claude.
  Vamos começar com um simples "Hello World".
MD

cell <<~RUBY, "Criando cliente Anthropic"
  require "ruby-anthropic"
  
  client = Anthropic::Client.new(
    access_token: ENV["ANTHROPIC_API_KEY"]
  )
  
  puts "Cliente criado com sucesso!"
  client.class
RUBY

cell <<~RUBY, "Enviando primeira mensagem"
  response = client.messages(
    parameters: {
      model: "claude-3-5-sonnet-20241022",
      messages: [
        {
          role: "user",
          content: "Olá Claude! Responda em português. O que você pode me dizer sobre Ruby on Rails em uma frase?"
        }
      ],
      max_tokens: 100
    }
  )
  
  # Extraindo o texto da resposta
  claude_response = response.dig("content", 0, "text")
  puts claude_response
RUBY

section "Usando Helper Functions"

markdown <<~MD
  O NotebookRunner fornece funções helper para facilitar o uso da API.
  Vamos testar o helper `ask_claude`:
MD

cell <<~RUBY, "Usando o helper ask_claude"
  response = ask_claude("Qual a diferença entre Python e Ruby? Responda em 2 bullets.")
  display_claude(response)
RUBY

section "Explorando Parâmetros"

markdown <<~MD
  Vamos explorar diferentes parâmetros da API:
  - model: modelo a usar
  - max_tokens: limite de tokens na resposta
  - temperature: criatividade (0-1)
MD

cell <<~RUBY, "Testando com diferentes temperaturas"
  # Temperature baixa = mais focado
  response_low = client.messages(
    parameters: {
      model: "claude-3-5-sonnet-20241022",
      messages: [{ role: "user", content: "Complete: Rails é..." }],
      max_tokens: 50,
      temperature: 0.1
    }
  )
  
  # Temperature alta = mais criativo
  response_high = client.messages(
    parameters: {
      model: "claude-3-5-sonnet-20241022",
      messages: [{ role: "user", content: "Complete: Rails é..." }],
      max_tokens: 50,
      temperature: 0.9
    }
  )
  
  puts "Temperature 0.1: #{response_low.dig('content', 0, 'text')}"
  puts "\nTemperature 0.9: #{response_high.dig('content', 0, 'text')}"
RUBY

section "System Prompts"

markdown <<~MD
  System prompts definem o comportamento e contexto da Claude.
  Vamos testar diferentes personas:
MD

cell <<~RUBY, "Claude como expert em Rails"
  response = client.messages(
    parameters: {
      model: "claude-3-5-sonnet-20241022",
      system: "Você é um expert em Ruby on Rails com 10 anos de experiência. Sempre sugira boas práticas e padrões Rails.",
      messages: [
        {
          role: "user",
          content: "Como devo organizar services em Rails?"
        }
      ],
      max_tokens: 200
    }
  )
  
  display_claude(response.dig("content", 0, "text"))
RUBY

section "Salvando a Sessão"

cell <<~RUBY, "Salvando notebook"
  $notebook.save_session("lesson_01_hello_claude")
RUBY

markdown <<~MD
  🎉 Parabéns! Você completou a primeira lição!
  
  Próximos passos:
  - Experimente diferentes modelos
  - Teste outros parâmetros
  - Crie suas próprias interações
MD