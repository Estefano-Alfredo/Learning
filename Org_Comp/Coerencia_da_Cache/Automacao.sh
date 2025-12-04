#!/bin/bash

# Arquivos executados, escritos e criados
TESTE1="Teste_1.c"
TESTE2="Teste_2.c"
PROG1="Teste_1"
PROG2="Teste_2"
TABELA="cache.csv"
GRAFICO="graph.png"

#Valores de ij para Matriz_{ij} e buffer com a linha a ser substituida
TAMANHOS=($(seq 250 250 25000))
LINHA_SUBS="#define TAM"

echo "Gerando tabela"

#cabeçalho do arquivo, cria o arquivo se precisar
echo "TAM(Ordem da Matriz), CACHE-Friendly(ms), Tempo CACHE-Miss(ms)" > $TABELA

#Loop
for TAM in ${TAMANHOS[@]}; do
    echo "TAM = $TAM"

    #atualiza TAM
    sed -i "s/^$LINHA_SUBS .*/$LINHA_SUBS $TAM/" $TESTE1
    sed -i "s/^$LINHA_SUBS .*/$LINHA_SUBS $TAM/" $TESTE2

    #recompilando 
    g++ -o $PROG1 $TESTE1
    if [$? -ne 0]; then echo "Erro de compilação em TAM = $TAM"; exit 1; fi
    g++ -o $PROG2 $TESTE2
    if [$? -ne 0]; then echo "Erro de compilação em TAM = $TAM"; exit 1; fi

    #rodando Testes
    TEMPO1=$(./$PROG1)
    TEMPO2=$(./$PROG2)

    #escreve no arquivo
    echo "$TAM, $TEMPO1, $TEMPO2" >> $TABELA
done

echo "Gerando gráfico"

gnuplot << EOF
    set terminal png size 1000, 600
    set output "$GRAFICO"
    set datafile separator ","
    set title "Gráfico Ordem x Tempo"
    set xlabel "Ordem da Matriz (TAM)"
    set ylabel "Tempo de Execução (ms)"
    set grid
    
    plot "$TABELA" using 1:2 title 'Acesso em Sequencia' with linespoints, \
         "" using 1:3 title 'Acesso Coluna em Coluna' with linespoints
EOF

echo "Aplicação finalizada com sucesso"