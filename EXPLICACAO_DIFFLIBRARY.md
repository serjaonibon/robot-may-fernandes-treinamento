# Guia Completo: DiffLibrary no Robot Framework

---

## 📚 O que é DiffLibrary?

A DiffLibrary é uma biblioteca do Robot Framework que **compara dois arquivos ou textos** e identifica as diferenças entre eles. É muito útil para testes de regressão (verificar se o conteúdo mudou indevidamente).

---

## 📄 Estrutura do Arquivo teste_diff.robot

### 1. Settings (Configurações)

```robotframework
*** Settings ***
Documentation    Teste de regressão de conteúdo usando a DiffLibrary.
Library          DiffLibrary
Library          OperatingSystem
```

**O que cada linha faz:**

- `Documentation`: Descreve o propósito do arquivo de testes
- `Library DiffLibrary`: Importa a biblioteca de comparação de arquivos
- `Library OperatingSystem`: Importa a biblioteca para criar/deletar/manipular arquivos

---

### 2. Variables (Variáveis)

```robotframework
*** Variables ***
${ARQUIVO_ATUAL}      resultado_atual.txt
${ARQUIVO_ESPERADO}   resultado_esperado.txt
```

**Explicação:**

Essas variáveis armazenam os **nomes dos arquivos** que serão comparados:

- `${ARQUIVO_ESPERADO}`: O arquivo "padrão" (resultado correto esperado)
- `${ARQUIVO_ATUAL}`: O arquivo "testado" (resultado gerado pelo sistema)

Os valores podem ser usados em qualquer lugar do arquivo usando a sintaxe `${NOME_DA_VARIAVEL}`

---

### 3. Keywords (Palavras-chave customizadas)

```robotframework
*** Keywords ***
Setup Arquivos de Exemplo
    # Prepara o arquivo esperado
    Create File    ${ARQUIVO_ESPERADO}    Linha 1: Início da saída\nLinha 2: Processamento concluído\nLinha 3: Dados finais ok.
    
    # Prepara o arquivo atual (idêntico ao esperado)
    Create File    ${ARQUIVO_ATUAL}    Linha 1: Início da saída\nLinha 2: Processamento concluído\nLinha 3: Dados finais ok.
    
    Log To Console    Arquivos de exemplo criados.
```

**O que faz:**

- Cria dois arquivos de texto com **conteúdo inicial idêntico**
- `\n` representa quebra de linha
- Usa a biblioteca OperatingSystem para criar os arquivos

**Linha por linha:**

| Conteúdo | Significado |
|----------|-------------|
| `Linha 1: Início da saída` | Inicialização do processo |
| `Linha 2: Processamento concluído` | Resultado do processamento |
| `Linha 3: Dados finais ok.` | Finalização |

---

### 4. Test Cases (Casos de Teste)

#### Cenário 1: Comparar Arquivos Idênticos

```robotframework
Cenario 1: Comparar Arquivos Identicos
    [Documentation]    Verifica se a DiffLibrary passa quando não há diferenças.
    Setup Arquivos de Exemplo
    
    # Chama a keyword que cria os arquivos de exemplo
    Diff Files    ${ARQUIVO_ATUAL}    ${ARQUIVO_ESPERADO}    fail=True
    
    Log To Console    \n--> SUCESSO: Os arquivos são idênticos, como esperado.
```

**O que acontece passo a passo:**

1. **Setup Arquivos de Exemplo**: 
   - Cria os dois arquivos com conteúdo idêntico
   - Ambos com as mesmas 3 linhas de texto

2. **Diff Files**: 
   - Compara os dois arquivos
   - `${ARQUIVO_ATUAL}`: arquivo testado
   - `${ARQUIVO_ESPERADO}`: arquivo esperado
   - `fail=True`: Se houver diferenças, o teste falha

3. **Log To Console**: 
   - Imprime mensagem de sucesso no console

**Resultado esperado:** ✅ **PASSA**

- Os arquivos são iguais
- Não há diferenças
- O teste continua normalmente

---

#### Cenário 2: Forçar Falha e Ver o Diff

```robotframework
Cenario 2: Forçar Falha e Ver o Diff
    [Documentation]    Demonstra a falha e o relatório detalhado da DiffLibrary.
    
    # Remove o arquivo antigo
    Remove File    ${ARQUIVO_ATUAL}
    
    # Cria um novo arquivo com conteúdo DIFERENTE
    Create File    ${ARQUIVO_ATUAL}    Linha 1: Início da saída\nLinha 2: Processamento ALTERADO\nLinha 3: Dados finais ok.
    
    # Compara os arquivos
    Diff Files    ${ARQUIVO_ATUAL}    ${ARQUIVO_ESPERADO}    fail=True
```

**O que acontece passo a passo:**

1. **Remove File**: 
   - Deleta o arquivo anterior

2. **Create File**: 
   - Cria um novo arquivo com **conteúdo DIFERENTE**
   - Mudou: `Processamento concluído` → `Processamento ALTERADO`

3. **Diff Files**: 
   - Compara os dois arquivos
   - Encontra a diferença na Linha 2
   - Como `fail=True`, o teste **falha propositalmente**

**Resultado esperado:** ❌ **FALHA** (propositalmente!)

**Diferença encontrada:**
```
Linha 2 esperada: Processamento concluído
Linha 2 atual:    Processamento ALTERADO
                                 ^^^^^^^^^ Diferença aqui!
```

---

## 🔄 Fluxo Completo de Execução

```
┌─────────────────────────────────────────┐
│  Iniciar testes                         │
└──────────────┬──────────────────────────┘
               │
               ▼
┌─────────────────────────────────────────┐
│  Cenário 1: Arquivos Idênticos          │
├─────────────────────────────────────────┤
│  1. Setup Arquivos de Exemplo           │
│     ├─ Cria resultado_esperado.txt      │
│     └─ Cria resultado_atual.txt         │
│        (ambos com mesmo conteúdo)       │
│                                         │
│  2. Diff Files compara                  │
│     ├─ Arquivo 1: resultado_atual.txt   │
│     └─ Arquivo 2: resultado_esperado.txt│
│                                         │
│  3. Resultado: IGUAIS ✅                 │
│     └─ Teste PASSA                      │
└──────────────┬──────────────────────────┘
               │
               ▼
┌─────────────────────────────────────────┐
│  Cenário 2: Arquivos com Diferenças     │
├─────────────────────────────────────────┤
│  1. Remove resultado_atual.txt           │
│                                         │
│  2. Cria novo resultado_atual.txt       │
│     com conteúdo DIFERENTE              │
│                                         │
│  3. Diff Files compara                  │
│     ├─ Arquivo 1: resultado_atual.txt   │
│     │  "Processamento ALTERADO"         │
│     └─ Arquivo 2: resultado_esperado.txt│
│        "Processamento concluído"        │
│                                         │
│  4. Resultado: DIFERENTES ❌             │
│     └─ Teste FALHA (esperado)           │
└──────────────┬──────────────────────────┘
               │
               ▼
┌─────────────────────────────────────────┐
│  Resultados Finais                      │
├─────────────────────────────────────────┤
│  Cenário 1: ✅ PASSOU                    │
│  Cenário 2: ❌ FALHOU (propositalmente)  │
│  Total: 1 passou, 1 falhou              │
│  Exit Code: 1 (indica falha)            │
└─────────────────────────────────────────┘
```

---

## 📊 Parâmetro `fail=True` da Keyword Diff Files

```robotframework
Diff Files    arquivo1    arquivo2    fail=True
```

**Explicação dos parâmetros:**

| Parâmetro | Valor | Significado |
|-----------|-------|-------------|
| `arquivo1` | `resultado_atual.txt` | Primeiro arquivo a comparar |
| `arquivo2` | `resultado_esperado.txt` | Segundo arquivo a comparar |
| `fail` | `True` | Se houver diferenças, o teste **falha** |

**Alternativas:**

- **`fail=True`**: Se houver diferenças, o teste **falha** (comportamento padrão)
- **`fail=False`**: Se houver diferenças, apenas **registra** mas não falha

---

## 🎯 Casos de Uso Reais

A DiffLibrary é útil em diversos cenários:

### 1. Teste de Saída de Software
- Comparar output gerado por um programa vs. output esperado
- Verificar se mensagens de log estão corretas

### 2. Teste de Regressão
- Comparar saída atual com saída anterior
- Garantir que mudanças no código não quebraram a funcionalidade

### 3. Validação de Relatórios
- Comparar relatórios gerados vs. padrão
- Verificar se formatação está correta

### 4. Testes de API
- Comparar JSON retornado vs. esperado
- Validar estrutura de resposta

### 5. Testes de Banco de Dados
- Comparar resultados de queries
- Validar exportação de dados

---

## ✅ Por que o Exit Code é 1?

Exit Code 1 significa que **pelo menos um teste falhou**. É **esperado e correto** neste caso, porque:

- **Cenário 1**: PASSOU ✅
- **Cenário 2**: FALHOU ❌ (propositalmente para demonstração)

**Tabela de Exit Codes:**

| Exit Code | Significado |
|-----------|-------------|
| 0 | Todos os testes passaram |
| 1 | Pelo menos um teste falhou |
| 2 | Erro de sintaxe ou configuração |
| 253 | Erro de importação de biblioteca |

---

## 🔧 Como Executar os Testes

### Executar todos os testes:
```bash
robot DiffLibrary/teste_diff.robot
```

### Executar um teste específico:
```bash
robot -t "Cenario 1: Comparar Arquivos Identicos" DiffLibrary/teste_diff.robot
```

### Gerar relatório em pasta específica:
```bash
robot -d ./results DiffLibrary/teste_diff.robot
```

### Usar ambiente virtual:
```bash
C:/RobotMay/.venv/Scripts/robot.exe DiffLibrary/teste_diff.robot
```

---

## 📝 Resumo Geral

| Aspecto | Detalhes |
|---------|----------|
| **Biblioteca** | DiffLibrary - compara arquivos/textos |
| **Variáveis** | Nomes dos arquivos a comparar |
| **Keywords** | Setup cria arquivos, Diff Files compara |
| **Cenário 1** | Arquivos idênticos → Teste PASSA |
| **Cenário 2** | Arquivos diferentes → Teste FALHA (intencional) |
| **Exit Code** | 1 (indica falha, que é esperada) |
| **Propósito** | Demonstrar comparação de arquivos |

---

## 📌 Dicas Importantes

1. **Sempre use ambiente virtual**: Certifique-se de que a DiffLibrary está instalada no ambiente virtual correto

2. **Verifique o PYTHONPATH**: Garanta que o Robot Framework está usando a mesma instalação Python

3. **Use fail=True com cuidado**: Apenas use quando quiser que o teste falhe em caso de diferenças

4. **Organize seus arquivos**: Mantenha arquivos esperados em um local consistente

5. **Documente seus testes**: Use `[Documentation]` para explicar cada cenário

---

## 🚀 Próximos Passos

Agora que você entende como funciona a DiffLibrary, você pode:

1. Adaptar os exemplos para seus arquivos reais
2. Comparar arquivos de log
3. Validar saída de programas
4. Criar testes de regressão mais complexos
5. Integrar com CI/CD pipelines

---

**Documento gerado em:** 13 de Dezembro de 2025

**Versão:** 1.0

**Robot Framework Version:** 7.3.2

**DiffLibrary Version:** 0.1.0