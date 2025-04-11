# MIPS de Ciclo Único

Um projeto de processador em System Verilog de uma arquitetura MIPS de ciclo único.  
Disponível para execução em:  
[https://www.edaplayground.com/x/5Eje](https://www.edaplayground.com/x/5Eje)

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
