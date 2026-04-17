# Jokenpo - Pedra, Papel e Tesoura 🎮

Projeto 01 — Aplicativo mobile desenvolvido em Flutter para a disciplina de Desenvolvimento de Aplicativos Mobile.

## Sobre o Projeto

Implementação do clássico jogo **Jokenpo** (Pedra, Papel e Tesoura) com interface gráfica em Flutter. O jogador disputa rodadas contra o computador, que faz suas escolhas de forma aleatória.

## Funcionalidades

- Escolha entre Pedra ✊, Papel ✋ ou Tesoura ✌️
- Destaque visual na opção selecionada pelo jogador
- Jogada do computador gerada aleatoriamente a cada rodada
- Exibição do resultado: vitória, derrota ou empate
- Placar acumulado entre as rodadas
- Botão para resetar o placar

## Regras do Jogo

- 🪨 Pedra ganha da Tesoura
- 📄 Papel ganha da Pedra
- ✂️ Tesoura ganha do Papel

## Como Executar

**Pré-requisitos:** Flutter SDK instalado ([instruções](https://docs.flutter.dev/get-started/install))

```bash
# Clone o repositório
git clone https://github.com/EZblack1/Jokenpo_flutter.git

# Entre na pasta do projeto
cd Jokenpo_flutter

# Instale as dependências
flutter pub get

# Execute o app
flutter run
```

## Estrutura do Projeto

```
lib/
└── main.dart   # Código principal do app (lógica + interface)

arquivo01.dart  # Cópia do código principal usada na atividade
```

## Tecnologias

- [Flutter](https://flutter.dev/) — Framework de UI multiplataforma
- [Dart](https://dart.dev/) — Linguagem de programação
- `dart:math` — Geração de números aleatórios para a jogada do computador

## Plataforma

- Funciona em Flutter (Android, Web e Desktop)
- Foco acadêmico: execução principal em Android

## Entrega

Arquivo ZIP nomeado conforme padrão: `APM_261_PR01_Nome01_Nome02.zip`  
(pasta do projeto sem a subpasta `build`)
