#include <time.h>
#include <stdio.h>
#include <stdlib.h>

// Descrição: Este programa gera um array de números flutuantes aleatórios 
// dentro de um intervalo definido com base no comprimento do array. Ele 
// recebe dois argumentos: o nome do arquivo de saída e o comprimento do 
// array. O array é gerado e armazenado em um arquivo binário, onde o 
// comprimento do array e seus valores são gravados.


// Variável global para armazenar o intervalo (range)
float intervalo;

void gerar_array_float_aleatorio(float *array, int comprimento) {
    // Preencher o array com valores aleatórios entre -intervalo e intervalo
    for (int i = 0; i < comprimento; i++) {
        array[i] = ((float)rand() / RAND_MAX) * (2 * intervalo) - intervalo; // Número float aleatório entre -intervalo e intervalo
    }
}

int main(int argc, char *argv[]) {
    // Verificar se o número de argumentos está correto
    if (argc != 3) {
        fprintf(stderr, "Uso: %s <arquivo_saida> <comprimento_array>\n", argv[0]);
        return 1;
    }

    const char *nome_arquivo = argv[1];  // Nome do arquivo de saída
    int comprimento = atoi(argv[2]);     // Comprimento do array

    // Validar o comprimento
    if (comprimento <= 0) {
        fprintf(stderr, "O comprimento do array deve ser um número inteiro positivo.\n");
        return 1;
    }

    // Definir o valor do intervalo globalmente
    intervalo = comprimento;  // Calcular o intervalo como uma variável global

    // Alocar memória para o array
    float *array = (float *)malloc(comprimento * sizeof(float));
    if (array == NULL) {
        fprintf(stderr, "Falha na alocação de memória\n");
        return 1;
    }

    // Inicializar o gerador de números aleatórios com base no tempo atual
    srand(time(NULL));

    // Gerar valores aleatórios para o array
    gerar_array_float_aleatorio(array, comprimento);

    // Abrir o arquivo para escrita em formato binário
    FILE *arquivo = fopen(nome_arquivo, "wb");
    if (arquivo == NULL) {
        fprintf(stderr, "Não foi possível abrir o arquivo para escrita\n");
        free(array);
        return 1;
    }

    // Escrever o comprimento do array no arquivo
    fwrite(&comprimento, sizeof(int), 1, arquivo);

    // Escrever o array no arquivo
    fwrite(array, sizeof(float), comprimento, arquivo);
    
    // Fechar o arquivo e liberar a memória alocada
    fclose(arquivo);
    free(array);

    return 0;
}
