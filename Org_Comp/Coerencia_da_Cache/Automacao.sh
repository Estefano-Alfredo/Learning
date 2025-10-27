#!/bin/bash

# Arquivos executados, escritos e criados
TESTE1="Teste_1.c"
TESTE2="Teste_2.c"
PROG1="Teste_1"
PROG2="Teste_2"
TABELA="cache.csv"
GRAFICO="graph.png"

#Valores de ij para Matriz_{ij} e buffer com a linha a ser substituida
TAMANHOS=(10 100 1000 5000 7500 10000 12000 14000 16000 18000 20000)
LINHA_SUBS="#define TAM"

#Inicio da automação
echo "Gerando tabela"

#Cria/sobrescreve tabela e insere cabeçalho
echo "TAM(Ordem da Matriz), Tempo CACHE-Friendly, Tempo CACHE-Miss" > $TABELA

#Loop de execução dos testes
for TAM in ${TAMANHOS[@]}; do
    echo "Testando TAM = $TAM"

    #parte 1: atualizar valor de TAM nos arquivos .c
    sed -i "s/^$LINHA_SUBS .*/$LINHA_SUBS $TAM/" $TESTE1
    sed -i "s/^$LINHA_SUBS .*/$LINHA_SUBS $TAM/" $TESTE2

    #compilando arquivos .c
    g++ -o $PROG1 $TESTE1
    if [$? -ne 0]; then echo "Erro de compilação do Teste 1 com TAM = $TAM. Encerrando execução..."; exit 1; fi
    g++ -o $PROG2 $TESTE2
    if [$? -ne 0]; then echo "Erro de compilação do Teste 2 com TAM = $TAM. Encerrando execução..."; exit 1; fi

    #Rodando Testes
    TEMPO1=$(./$PROG1)
    TEMPO2=$(./$PROG2)

    #Escrevendo resultados na tabela
    echo "$TAM, $TEMPO1, $TEMPO2" >> $TABELA
done

#Criando gráfico
echo "Gerando gráfico"

gnuplot << EOF
    set terminal png size 1000, 600
    set output "$GRAFICO"
    set title "Gráfico Ordem x Tempo"
    set xlabel "Ordem da Matriz (TAM)"
    set ylabel "Tempo de Execução (ms)"
    set grid
    
    plot "$TABELA" using 1:2 title 'Acesso em Sequencia' with linespoints, \
         "" using 1:3 title 'Acesso Coluna em Coluna' with linespoints
EOF

echo "Aplicação finalizada com sucesso"