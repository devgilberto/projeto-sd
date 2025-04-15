# MIPS de Ciclo Único

Um projeto de processador em System Verilog de uma arquitetura MIPS de ciclo único.  
Disponível para execução em:  
https://www.edaplayground.com/x/q5vb
---

# Funcionalidades do MIPS

MIPS_connectivity(main).sv
Este é o módulo principal em SystemVerilog que integra todos os componentes do processador MIPS monociclo. Ele define o datapath e conecta os submódulos (como ALU, banco de registradores, memórias e unidade de controle) usando fios e portas, formando a arquitetura completa do processador.

MIPS_controller.txt
Contém a descrição ou implementação da unidade de controle. Especifica os sinais de controle (ex.: RegWrite, MemWrite, ALUSrc) gerados com base no opcode da instrução, coordenando o comportamento dos outros componentes do processador.

MIPS_datapath_components.txt
Descreve os componentes do datapath, como o Program Counter (PC), banco de registradores, ALU, memória de instruções e memória de dados. Detalha como esses elementos processam os dados durante a execução de uma instrução.

MIPS_instructions.txt
Lista as instruções MIPS suportadas pelo processador, binário ou hexadecimal. Pode incluir exemplos de programas ou a codificação das instruções para carregar na memória de instruções.

MIPS_testbench.txt
Define o testbench para simulação do processador. Inclui a instanciação do módulo principal, geração de clock, inicialização do sistema (ex.: reset, carregamento de instruções) e monitoramento das saídas para verificar o funcionamento correto.

---

## Dados da arquitetura e microarquitetura

- Suporta instruções MIPS padrão de 32 bits
- Possui 32 registradores de dados de 32 bits
- Possui memória de dados de 256 bytes

### Estrutura das instruções

#### Tipo R (add, sub, set less than, jump register)
| Op     | rs     | rt     | rd     | shamt  | funct  |
|--------|--------|--------|--------|--------|--------|
| 6 bits | 5 bits | 5 bits | 5 bits | 5 bits | 6 bits |

#### Tipo I (load word, store word, branch not equal, branch equal, add immediate, load upper immediate)
| Op     | rs     | rt     | Valor imediato / deslocamento de endereço (em complemento de 2) |
|--------|--------|--------|---------------------------------------------------------------|
| 6 bits | 5 bits | 5 bits | 16 bits                                                       |

### Instruções comuns e sinais de controle

| Instrução | Opcode | Funct | ALUOp | Controle ALU | Função |
|-----------|--------|-------|-------|--------------|--------|
| lw        | 35     | --    | 00    | 010          | ADD    |
| sw        | 43     | --    | 00    | 010          | ADD    |
| beq       | 4      | --    | 01    | 110          | SUB    |
| add       | 0      | 32    | 10    | 010          | ADD    |
| sub       | 0      | 34    | 10    | 110          | SUB    |
| and       | 0      | 36    | 10    | 000          | AND    |
| or        | 0      | 37    | 10    | 001          | OR     |
| slt       | 0      | 42    | 10    | 111          | SLT    |
