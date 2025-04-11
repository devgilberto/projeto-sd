# MIPS de Ciclo Único

Um projeto de processador em System Verilog de uma arquitetura MIPS de ciclo único.  
Disponível para execução em:  
[https://www.edaplayground.com/x/5Eje](https://www.edaplayground.com/x/5Eje)

---
# Passo a passo de como rodar a simulação e explicação do output
Verifique os Arquivos  
No painel esquerdo, confira:
MIPS_connectivity.sv: Contém o processador MIPS monociclo com memória de instruções inicializada com um programa de teste (ex.: addi $v0, $zero, 5).

testbench.sv: Configura clock, reset e monitora saídas (PC, instruções, registradores).

O programa de teste na memória de instruções realiza operações como carregar valores, subtração e OR.

Configure a Simulação  
No menu superior, selecione:
Tool: Icarus Verilog (ou ModelSim, se disponível).

Language: SystemVerilog.

Marque testbench.sv como o testbench principal.

Em "Run Options", deixe o tempo de simulação padrão (ex.: 100ns) ou ajuste para #200 em testbench.sv se necessário.

(Opcional) Ative o "Dump VCD" para gerar waveforms.

Execute a Simulação  
Clique no botão Run.  

O EDA Playground compilará os arquivos e rodará o testbench, simulando o processador executando o programa.

Verifique as Saídas  
No console (abaixo do código), veja as saídas geradas por $monitor. Exemplo:

Time=0   PC=00000000 Instr=20020005 Reg_v0=xxxxxxxx
Time=10  PC=00000004 Instr=2003000c Reg_v0=00000005
Time=20  PC=00000008 Instr=2067fff7 Reg_v1=0000000c

Isso mostra:
O PC avançando (0, 4, 8, ...).

Instruções executadas (ex.: 20020005 é addi $v0, $zero, 5).

Registradores atualizados (ex.: $v0 = 5, $v1 = 12).

(Opcional) Clique em View Waveforms para visualizar sinais como clock, PC e registradores.



---

# Funcionalidades do MIPS

MIPS_connectivity(main).sv
Este é o módulo principal em SystemVerilog que integra todos os componentes do processador MIPS monociclo. Ele define o datapath e conecta os submódulos (como ALU, banco de registradores, memórias e unidade de controle) usando fios e portas, formando a arquitetura completa do processador.

MIPS_controller.txt
Contém a descrição ou implementação da unidade de controle. Especifica os sinais de controle (ex.: RegWrite, MemWrite, ALUSrc) gerados com base no opcode da instrução, coordenando o comportamento dos outros componentes do processador.

MIPS_datapath_components.txt
Descreve os componentes do datapath, como o Program Counter (PC), banco de registradores, ALU, memória de instruções e memória de dados. Detalha como esses elementos processam os dados durante a execução de uma instrução.

MIPS_instructions.txt
Lista as instruções MIPS suportadas pelo processador, possivelmente em formato assembly, binário ou hexadecimal. Pode incluir exemplos de programas ou a codificação das instruções para carregar na memória de instruções.

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
