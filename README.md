# Slice Sampling como alternativa ao Método de Rejeição

Esse projeto pretende analisar o algoritmo de slice sampling para avaliar se pode ser utilizado como uma alternativa viável e
melhorada para o método de rejeição, incluindo simulações com dados reais e avaliações com foco em desempenho e eficiência.

# Resultados

| Tamanho de n | Tempo de execução (Método de Rejeição) | Tempo de execução (Slice Sampling) |
|--------------|----------------------------------------|-------------------------------------|
| 1000         | 0.1318319 secs                        | 1.433258 mins                      |
| 2000         | 0.1039279 secs                        | 2.727945 mins                      |
| 5000         | 0.441499 secs                         | 6.160423 mins                      |

**Tabela 1:** Comparação de tempo de execução entre métodos de amostragem na base de dados 1

| Tamanho de n | Tempo de execução (Método de Rejeição) | Tempo de execução (Slice Sampling) |
|--------------|----------------------------------------|-------------------------------------|
| 200         | 0.076092 secs                           | 10.45552 mins                      |
| 500         | 0.06464791 secs                         | 32.27823 mins                      |

**Tabela 2:** Comparação de tempo de execução entre métodos de amostragem na base de dados 2

Como conclusão do projeto, tem-se que o melhor método para sampling varia a cada caso, sendo o slice sampling mais preciso em todos os casos, mas gerando um custo computacional muito maior, que pode ser prejudicial em casos de bases de dados grandes.

Para resultados mais detalhados, [acesse o relatório](docs/relatorio.pdf)
