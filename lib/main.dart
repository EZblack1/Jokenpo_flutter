import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Jokenpo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        scaffoldBackgroundColor: const Color(0xFF1A1A2E),
        fontFamily: 'monospace',
      ),
      home: const JokenpoPage(),
    );
  }
}

class JokenpoPage extends StatefulWidget {
  const JokenpoPage({super.key});

  @override
  State<JokenpoPage> createState() => _JokenpoPageState();
}

class _JokenpoPageState extends State<JokenpoPage>
    with SingleTickerProviderStateMixin {
  // 1 = Pedra, 2 = Papel, 3 = Tesoura, 0 = não escolhido
  int _escolhaJogador = 0;
  int _escolhaComputador = 0;
  String _resultado = '';
  bool _jogouUmaVez = false;

  // Placar
  int _vitoriasJogador = 0;
  int _vitoriasComputador = 0;
  int _empates = 0;

  late AnimationController _animController;
  late Animation<double> _scaleAnim;

  final Map<int, String> _opcaoEmoji = {
    1: '✊',
    2: '✋',
    3: '✌️',
  };

  final Map<int, String> _opcaoNome = {
    1: 'Pedra',
    2: 'Papel',
    3: 'Tesoura',
  };

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _scaleAnim = Tween<double>(begin: 0.7, end: 1.0).animate(
      CurvedAnimation(parent: _animController, curve: Curves.elasticOut),
    );
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _selecionarJogador(int opcao) {
    setState(() {
      _escolhaJogador = opcao;
      _resultado = '';
      _escolhaComputador = 0;
      _jogouUmaVez = false;
    });
  }

  void _jogar() {
    if (_escolhaJogador == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Escolha uma opção antes de jogar!'),
          backgroundColor: Colors.orange.shade700,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    var random = Random();
    int computador = random.nextInt(3) + 1;

    String resultado = _verificarVencedor(_escolhaJogador, computador);

    setState(() {
      _escolhaComputador = computador;
      _resultado = resultado;
      _jogouUmaVez = true;

      if (resultado == 'Você venceu! 🎉') {
        _vitoriasJogador++;
      } else if (resultado == 'Você perdeu! 😢') {
        _vitoriasComputador++;
      } else {
        _empates++;
      }
    });

    _animController.reset();
    _animController.forward();
  }

  String _verificarVencedor(int jogador, int computador) {
    if (jogador == computador) {
      return 'Empatou! 🤝';
    }
    // Pedra(1) ganha Tesoura(3)
    // Papel(2) ganha Pedra(1)
    // Tesoura(3) ganha Papel(2)
    if ((jogador == 1 && computador == 3) ||
        (jogador == 2 && computador == 1) ||
        (jogador == 3 && computador == 2)) {
      return 'Você venceu! 🎉';
    }
    return 'Você perdeu! 😢';
  }

  void _resetarPlacar() {
    setState(() {
      _vitoriasJogador = 0;
      _vitoriasComputador = 0;
      _empates = 0;
      _escolhaJogador = 0;
      _escolhaComputador = 0;
      _resultado = '';
      _jogouUmaVez = false;
    });
  }

  Color get _corResultado {
    if (_resultado.contains('venceu')) return const Color(0xFF00E676);
    if (_resultado.contains('perdeu')) return const Color(0xFFFF5252);
    if (_resultado.contains('Empatou')) return const Color(0xFFFFD740);
    return Colors.white;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF1A1A2E),
                Color(0xFF16213E),
                Color(0xFF0F3460),
              ],
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Título
                  _buildTitulo(),
                  const SizedBox(height: 20),

                  // Placar
                  _buildPlacar(),
                  const SizedBox(height: 24),

                  // Área do jogador
                  _buildAreaJogador(),
                  const SizedBox(height: 20),

                  // Área do confronto (após jogar)
                  if (_jogouUmaVez) ...[
                    _buildAreaConfronto(),
                    const SizedBox(height: 20),
                  ],

                  // Botão Jogar
                  _buildBotaoJogar(),
                  const SizedBox(height: 16),

                  // Resultado
                  if (_resultado.isNotEmpty) _buildResultado(),

                  const SizedBox(height: 20),

                  // Botão resetar placar
                  TextButton.icon(
                    onPressed: _resetarPlacar,
                    icon: const Icon(Icons.refresh, color: Colors.white54, size: 18),
                    label: const Text(
                      'Resetar Placar',
                      style: TextStyle(color: Colors.white54, fontSize: 14),
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTitulo() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            gradient: const LinearGradient(
              colors: [Color(0xFF533483), Color(0xFFE94560)],
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFE94560).withValues(alpha: 0.4),
                blurRadius: 20,
                spreadRadius: 2,
              ),
            ],
          ),
          child: const Text(
            'JOKENPO',
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.w900,
              letterSpacing: 6,
            ),
          ),
        ),
        const SizedBox(height: 6),
        const Text(
          'Pedra • Papel • Tesoura',
          style: TextStyle(
            color: Colors.white38,
            fontSize: 13,
            letterSpacing: 2,
          ),
        ),
      ],
    );
  }

  Widget _buildPlacar() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildPlacarItem('Você', _vitoriasJogador, const Color(0xFF00E676)),
          _buildDivisorPlacar(),
          _buildPlacarItem('Empates', _empates, const Color(0xFFFFD740)),
          _buildDivisorPlacar(),
          _buildPlacarItem('CPU', _vitoriasComputador, const Color(0xFFFF5252)),
        ],
      ),
    );
  }

  Widget _buildPlacarItem(String label, int valor, Color cor) {
    return Column(
      children: [
        Text(
          '$valor',
          style: TextStyle(
            color: cor,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: const TextStyle(color: Colors.white54, fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildDivisorPlacar() {
    return Container(width: 1, height: 40, color: Colors.white12);
  }

  Widget _buildAreaJogador() {
    return Column(
      children: [
        const Text(
          'Escolha uma Opção',
          style: TextStyle(
            color: Colors.white70,
            fontSize: 16,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 14),
        Row(
          children: [
            _buildOpcao(1),
            const SizedBox(width: 10),
            _buildOpcao(2),
            const SizedBox(width: 10),
            _buildOpcao(3),
          ],
        ),
      ],
    );
  }

  Widget _buildOpcao(int opcao) {
    bool selecionado = _escolhaJogador == opcao;
    return Expanded(
      child: GestureDetector(
        onTap: () => _selecionarJogador(opcao),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: selecionado
              ? const Color(0xFFE94560).withValues(alpha: 0.25)
              : Colors.white.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: selecionado
                  ? const Color(0xFFE94560)
                  : Colors.white12,
              width: selecionado ? 2.5 : 1,
            ),
            boxShadow: selecionado
                ? [
                    BoxShadow(
                      color: const Color(0xFFE94560).withValues(alpha: 0.4),
                      blurRadius: 16,
                      spreadRadius: 1,
                    )
                  ]
                : [],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                _opcaoEmoji[opcao]!,
                style: TextStyle(
                  fontSize: selecionado ? 44 : 36,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                _opcaoNome[opcao]!,
                style: TextStyle(
                  color: selecionado ? Colors.white : Colors.white60,
                  fontSize: 12,
                  fontWeight: selecionado
                      ? FontWeight.bold
                      : FontWeight.normal,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAreaConfronto() {
    return ScaleTransition(
      scale: _scaleAnim,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white12),
        ),
        child: Row(
          children: [
            // Jogador
            Expanded(
              child: Column(
                children: [
                  const Text('Você',
                      style: TextStyle(color: Colors.white54, fontSize: 12, letterSpacing: 1)),
                  const SizedBox(height: 8),
                  Text(
                    _opcaoEmoji[_escolhaJogador] ?? '',
                    style: const TextStyle(fontSize: 52),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    _opcaoNome[_escolhaJogador] ?? '',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            // VS
            Column(
              children: const [
                Text(
                  'VS',
                  style: TextStyle(
                    color: Colors.white24,
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 2,
                  ),
                ),
              ],
            ),
            // Computador
            Expanded(
              child: Column(
                children: [
                  const Text('CPU',
                      style: TextStyle(color: Colors.white54, fontSize: 12, letterSpacing: 1)),
                  const SizedBox(height: 8),
                  Text(
                    _opcaoEmoji[_escolhaComputador] ?? '',
                    style: const TextStyle(fontSize: 52),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    _opcaoNome[_escolhaComputador] ?? '',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBotaoJogar() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _jogar,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFE94560),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          elevation: 8,
          shadowColor: const Color(0xFFE94560).withValues(alpha: 0.5),
        ),
        child: const Text(
          'JOGAR',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w900,
            letterSpacing: 4,
          ),
        ),
      ),
    );
  }

  Widget _buildResultado() {
    return ScaleTransition(
      scale: _scaleAnim,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
        decoration: BoxDecoration(
          color: _corResultado.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: _corResultado.withValues(alpha: 0.5),
            width: 1.5,
          ),
        ),
        child: Text(
          _resultado,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: _corResultado,
            fontSize: 22,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
      ),
    );
  }
}