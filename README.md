# Claude API Learning - Rails Edition 🚀

Este é um projeto Rails configurado para aprender e experimentar com a API da Claude (Anthropic). O objetivo é portar os exercícios do curso oficial da Anthropic de Python para Ruby, criando uma experiência similar a Jupyter Notebooks dentro do ecossistema Rails.

## 🎯 Objetivos do Projeto

- **Aprender a API da Claude**: Seguir o curso oficial adaptando para Ruby/Rails
- **Notebook-like Experience**: Sistema de execução de código similar ao Jupyter
- **Exemplos Práticos**: Implementar casos de uso reais em Rails
- **Chat Clone**: Eventualmente criar um clone da interface Claude.ai

## 📋 Pré-requisitos

- Ruby (versão do seu sistema)
- Rails 8.0.2+
- Uma conta na Anthropic com API key

## 🔧 Configuração Inicial

### 1. Instalar Dependências

```bash
bundle install
yarn install
```

### 2. Configurar API Key

1. Obtenha sua API key em: https://console.anthropic.com/settings/keys
2. Configure o arquivo `.env`:

```bash
cp .env.example .env
```

3. Edite `.env` e adicione sua API key:

```env
ANTHROPIC_API_KEY=sk-ant-api03-...sua-key-aqui...
```

## 📚 Estrutura do Projeto

```
claude_boilerplate/
├── app/
│   └── services/
│       └── claude/
│           └── client_service.rb    # Service para interagir com a API
├── lib/
│   ├── claude_course/
│   │   ├── lessons/                 # Lições do curso
│   │   │   └── 01_hello_claude.rb   # Primeira lição
│   │   ├── exercises/               # Exercícios práticos
│   │   │   └── exercise_template.rb # Template para exercícios
│   │   ├── notebooks/               # Sessões salvas (JSON)
│   │   └── notebook_runner.rb      # Engine do notebook
│   └── tasks/
│       └── claude/
│           └── notebook.rake        # Tasks rake para notebooks
```

## 🚀 Como Usar

### Executando Notebooks

O sistema de notebooks permite executar código Ruby de forma interativa, similar ao Jupyter:

#### 1. Executar uma lição:

```bash
rails claude:notebook FILE=lib/claude_course/lessons/01_hello_claude.rb
```

#### 2. Console interativo:

```bash
rails claude:console
```

No console, você pode:

```ruby
# Criar uma instância do notebook
notebook = ClaudeCourse::NotebookRunner.new

# Executar código
notebook.run_cell("puts 'Hello World!'")

# Fazer perguntas à Claude
response = notebook.ask_claude("O que é Rails?")
notebook.display_claude_response(response)

# Adicionar seções e markdown
notebook.section("Minha Seção")
notebook.markdown("## Título\n\nTexto em markdown")

# Salvar a sessão
notebook.save_session("minha_sessao")
```

### Criando Seus Próprios Notebooks

Crie um arquivo em `lib/claude_course/` com a estrutura:

```ruby
# lib/claude_course/meu_notebook.rb

section "Título da Seção"

markdown <<~MD
  Descrição em Markdown
MD

cell <<~RUBY, "Descrição do código"
  # Seu código Ruby aqui
  puts "Hello!"
RUBY

# Interagir com Claude
response = ask_claude("Sua pergunta aqui")
display_claude(response)
```

Execute com:

```bash
rails claude:notebook FILE=lib/claude_course/meu_notebook.rb
```

### Usando o Service no Rails

Para integrar a API da Claude em controllers ou outros services:

```ruby
# Em um controller ou service
claude = Claude::ClientService.new

# Chat simples
response = claude.chat("Olá Claude!")
puts response[:content]

# Com parâmetros customizados
response = claude.chat(
  "Explique MVC",
  model: "claude-3-5-sonnet-20241022",
  max_tokens: 500,
  temperature: 0.7,
  system: "Você é um professor de Rails"
)

# Stream de resposta
claude.stream_chat("Conte uma história") do |event|
  print event.dig("delta", "text") if event["type"] == "content_block_delta"
end
```

## 📖 Exemplos de Uso

### Exemplo 1: Primeira Interação

```ruby
# No console Rails ou notebook
client = Anthropic::Client.new(access_token: ENV["ANTHROPIC_API_KEY"])

response = client.messages(
  parameters: {
    model: "claude-3-5-sonnet-20241022",
    messages: [{ role: "user", content: "Olá!" }],
    max_tokens: 100
  }
)

puts response.dig("content", 0, "text")
```

### Exemplo 2: Análise de Código

```ruby
code = File.read("app/models/user.rb")

prompt = "Analise este modelo Rails e sugira melhorias:\n\n#{code}"

response = ask_claude(prompt, max_tokens: 500)
display_claude(response)
```

### Exemplo 3: Geração de Testes

```ruby
method_code = <<~RUBY
  def calculate_discount(price, percentage)
    price * (1 - percentage / 100.0)
  end
RUBY

prompt = "Gere testes RSpec para este método:\n#{method_code}"

response = ask_claude(prompt)
puts response
```

## 🎓 Seguindo o Curso

O curso oficial da Anthropic está em: https://anthropic.skilljar.com/claude-with-the-anthropic-api/

Para cada módulo do curso:

1. Crie um novo arquivo em `lib/claude_course/lessons/`
2. Porte os exemplos de Python para Ruby
3. Execute usando o sistema de notebooks
4. Experimente e adapte para Rails quando relevante

### Estrutura Sugerida para Lições:

- `01_hello_claude.rb` - Primeira interação ✅
- `02_parameters.rb` - Explorando parâmetros
- `03_system_prompts.rb` - System prompts
- `04_conversation.rb` - Conversações multi-turn
- `05_vision.rb` - Análise de imagens
- `06_tools.rb` - Function calling
- `07_streaming.rb` - Respostas em stream
- `08_rails_integration.rb` - Integração com Rails

## 🛠️ Comandos Úteis

```bash
# Executar notebook
rails claude:notebook FILE=path/to/notebook.rb

# Console interativo
rails claude:console

# Console Rails normal
rails console

# Listar notebooks disponíveis
rails claude:notebook
```

## 📝 Notas de Desenvolvimento

- **Segurança**: Nunca commite sua API key. Use sempre variáveis de ambiente
- **Limites**: A API tem limites de rate e tokens. Monitore seu uso
- **Modelos**: Atualmente usando `claude-3-5-sonnet-20241022`. Outros modelos disponíveis
- **Custos**: Cada chamada à API tem um custo. Verifique os preços em anthropic.com

## 🚧 Roadmap

- [ ] Mais lições do curso portadas
- [ ] Interface web para notebooks
- [ ] Sistema de chat completo
- [ ] Integração com Action Cable para streaming
- [ ] Dashboard de uso da API
- [ ] Exemplos de prompts avançados
- [ ] Testes automatizados

## 📄 Licença

Este é um projeto educacional para aprender a usar a API da Claude com Rails.

## 🤝 Contribuindo

Sinta-se à vontade para adicionar novos exemplos, lições ou melhorias ao sistema de notebooks!

---

**Lembre-se**: Configure sua API key antes de começar! 🔑