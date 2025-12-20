*** Settings ***
Documentation    Teste de regressão de conteúdo usando a DiffLibrary.
Library          DiffLibrary
# Adicionamos a OperatingSystem para criar arquivos de exemplo e forçar o teste
Library          OperatingSystem

*** Variables ***
${ARQUIVO_ATUAL}    resultado_atual.txt
${ARQUIVO_ESPERADO}    resultado_esperado.txt

*** Keywords ***
Setup Arquivos de Exemplo
    # Prepara o arquivo que o teste "espera"
    Create File    ${ARQUIVO_ESPERADO}    Linha 1: Início da saída\nLinha 2: Processamento concluído\nLinha 3: Dados finais ok.
    # Prepara o arquivo que o sistema "gerou" (Neste caso, ele é igual ao esperado)
    Create File    ${ARQUIVO_ATUAL}    Linha 1: Início da saída\nLinha 2: Processamento concluído\nLinha 3: Dados finais ok.
    Log To Console    Arquivos de exemplo criados.

*** Test Cases ***
Cenario 1: Comparar Arquivos Identicos
    [Documentation]    Verifica se a DiffLibrary passa quando não há diferenças.
    Setup Arquivos de Exemplo
    
    # 1. Palavra-chave principal: O teste PASSARÁ se os arquivos forem iguais.
    Diff Files    ${ARQUIVO_ATUAL}    ${ARQUIVO_ESPERADO}    fail=True
    
    Log To Console    \n--> SUCESSO: Os arquivos são idênticos, como esperado.

Cenario 2: Forçar Falha e Ver o Diff
    [Documentation]    Demonstra a falha e o relatório detalhado da DiffLibrary.
    # Recria os arquivos (O esperado é o mesmo)
    Remove File    ${ARQUIVO_ATUAL}
    Create File    ${ARQUIVO_ATUAL}    Linha 1: Início da saída\nLinha 2: Processamento ALTERADO\nLinha 3: Dados finais ok.
    # 2. Palavra-chave principal: O teste IRÁ FALHAR devido à diferença na Linha 2.
    # O log do Robot Framework irá mostrar: < Linha 2: Processamento concluído vs > Linha 2: Processamento ALTERADO
    # Nota: Este teste deve FALHAR (esperado) para demonstrar a funcionalidade.
    Diff Files    ${ARQUIVO_ATUAL}    ${ARQUIVO_ESPERADO}    fail=True