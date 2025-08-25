# Exercise Template
# Use este template como base para criar novos exercícios

section "Nome do Exercício"

markdown <<~MD
  ## Objetivo
  Descreva o objetivo do exercício aqui.
  
  ## Instruções
  1. Passo 1
  2. Passo 2
  3. Passo 3
MD

# ========================================
# SEU CÓDIGO AQUI
# ========================================

cell <<~RUBY, "Descrição do que este código faz"
  # Escreva seu código aqui
  puts "Hello from exercise!"
RUBY

# ========================================
# TESTES E VALIDAÇÃO
# ========================================

section "Validação"

cell <<~RUBY, "Testando a solução"
  # Adicione testes para validar a solução
  expected = "resultado esperado"
  actual = "seu resultado"
  
  if expected == actual
    puts "✅ Correto!"
  else
    puts "❌ Tente novamente"
    puts "Esperado: #{expected}"
    puts "Recebido: #{actual}"
  end
RUBY

# ========================================
# SOLUÇÃO (OPCIONAL)
# ========================================

markdown <<~MD
  ## Solução
  
  <details>
  <summary>Clique para ver a solução</summary>
  
  ```ruby
  # Código da solução aqui
  ```
  
  </details>
MD