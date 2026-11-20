import 'package:flutter/material.dart';

class Perfil extends StatefulWidget {
  const Perfil({super.key});

  @override
  State<Perfil> createState() => _PerfilState();
}

class _PerfilState extends State<Perfil> {
  final TextEditingController _searchController = TextEditingController();

  int _currentIndex = 0;
  String _searchedTerm = '';
  bool _hasSearched = false;
  String? _errorMessage;

  final Set<String> _receitasFavoritas = {};

  static const corFundo = Color(0xFFFBF3E8);
  static const corCaixaClara = Color(0xFFE8DCC8);
  static const corBordaIcone = Color(0xFFCBBBA0);
  static const corTextoSecundario = Color(0xFF8A6F57);
  static const corPrincipalEscura = Color(0xFF3B2B24);

  final List<Map<String, Object>> _todasAsReceitas = [
  {
  'nome': 'Chocolate Quente',
  'tempo': '10 min • Fácil',
  'tempoTotal': '10 min',
  'nota': '5 / 5',
  'icone': Icons.coffee,
  'porcoes': '1',
  'ingredientes': [
  '350g de leite',
  '100g de creme de leite',
  '90g de chocolate meio amargo',
  '10g de chocolate em pó'
  ],
  'passos': [
  'Em uma panela, derreta o chocolate com o creme de leite.',
  'Adicione o leite e o chocolate em pó e misture bem.',
  'Mexa sem parar até ferver e engrossar e sirva em uma caneca.'
  ]
  },
  {
  'nome': 'Matcha Latte',
  'tempo': '10 min • Fácil',
  'tempoTotal': '10 min',
  'nota': '4.0 / 5',
  'icone': Icons.emoji_food_beverage_rounded,
  'porcoes': '1',
  'ingredientes': [
  '1 colher de chá de matcha em pó',
  '60ml de água quente (não fervendo)',
  '200ml de leite (ou leite vegetal)',
  'Açúcar a gosto'
  ],
  'passos': [
  'Coloque o matcha na xícara.',
  'Adicione a água quente e bata até espumar.',
  'Aqueça o leite e adicione à xícara.',
  'Adoce com açúcar e aproveite.'
  ]
  },
  {
  'nome': 'Croissant',
  'tempo': '1h 20 min • Médio',
  'tempoTotal': '1h 20 min',
  'nota': '4.8 / 5',
  'icone': Icons.bakery_dining,
  'porcoes': '30',
  'ingredientes': [
    '900g de farinha de trigo',
    '150g de margarina',
    '1/2 litro de leite',
    '2 tabletes de fermento biológico (30g)',
    '1 colher rasa (sobremesa) de sal',
    '2 colheres (sopa) de açúcar',
    '1 gema para pincelar'
  ],
  'passos': [
    'Em uma tigela coloque o fermento e o açúcar, misture até dissolver o fermento.',
    'Acrescente o leite, o sal e a farinha de trigo.',
    'Amasse bem até obter uma massa bem homogênea e lisa.',
    'Em uma superfície levemente esfarinhada abra massa com o auxílio de um rolo.',
    'Passe margarina na massa aberta, depois dobre e passe o rolo para espalhar a margarina.',
    'Repita a operação 3 vezes.',
    'Corte as bordas para a massa folhar.',
    'Corte a massa em formato de um triângulo.',
    'Enrole da parte maior para a menor.',
    'Coloque em uma assadeira e pincele com 1 gema levemente batida, sal a gosto e 1 colher de sobremesa de óleo.',
    'Deixe crescer até dobrar de volume.',
    'Leve ao forno preaquecido, em temperatura média, para assar até os croissants ficarem dourados.'
  ]
  },
  ];

  void _realizarPesquisa() {
    final textoDigitado = _searchController.text;

    if (textoDigitado.trim().isEmpty) {
      setState(() {
        _errorMessage = 'O campo não pode estar vazio.';
        _hasSearched = false;
      });
    } else {
      setState(() {
        _errorMessage = null;
        _searchedTerm = textoDigitado.trim();
        _hasSearched = true;
      });
    }
  }

  void _limparPesquisa() {
    setState(() {
      _searchController.clear();
      _errorMessage = null;
      _searchedTerm = '';
      _hasSearched = false;
    });
  }

  void _toggleFavorito(String nomeReceita) {
    setState(() {
      if (_receitasFavoritas.contains(nomeReceita)) {
        _receitasFavoritas.remove(nomeReceita);
      } else {
        _receitasFavoritas.add(nomeReceita);
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Widget _buildReceitaCard(Map<String, dynamic> receita) {
    final nome = receita['nome'] as String;
    final isFavorito = _receitasFavoritas.contains(nome);

    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TelaReceita(
                receita: receita,
                isFavoritoInicial: _receitasFavoritas.contains(nome),
                onToggleFavorito: () => _toggleFavorito(nome),
              ),
            ),
          );
        },
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: corBordaIcone),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: corCaixaClara,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(receita['icone'] as IconData, color: corTextoSecundario, size: 40),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      nome,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: corPrincipalEscura),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      receita['tempo'] as String,
                      style: const TextStyle(fontSize: 12, color: corTextoSecundario),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          receita['nota'] as String,
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: corPrincipalEscura),
                        ),
                        GestureDetector(
                          onTap: () => _toggleFavorito(nome),
                          child: Icon(
                            isFavorito ? Icons.favorite : Icons.favorite_border,
                            size: 24,
                            color: isFavorito ? Colors.red : corPrincipalEscura,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAbaExplorar() {
    final receitasExibidas = _hasSearched
        ? _todasAsReceitas.where((receita) {
      return (receita['nome'] as String).toLowerCase().contains(_searchedTerm.toLowerCase());
    }).toList()
        : _todasAsReceitas;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 2),
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Ex: Croissant',
              hintStyle: const TextStyle(color: corTextoSecundario),
              prefixIcon: const Icon(Icons.search, color: corTextoSecundario),
              filled: true,
              fillColor: Colors.white,
              errorText: _errorMessage,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: corBordaIcone),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: corPrincipalEscura, width: 2),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.red, width: 1),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.red, width: 2),
              ),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: _realizarPesquisa,
              style: ElevatedButton.styleFrom(
                backgroundColor: corPrincipalEscura,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Pesquisar',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(height: 32),
          Text(
            _hasSearched ? 'Resultados para "$_searchedTerm"' : 'Receitas disponíveis',
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: corPrincipalEscura),
          ),
          const SizedBox(height: 4),
          Text(
            _hasSearched ? 'Toque na receita para ver o preparo.' : 'Selecione uma receita para ver seu preparo.',
            style: const TextStyle(fontSize: 14, color: corTextoSecundario),
          ),
          const SizedBox(height: 16),
          if (receitasExibidas.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 30),
              child: Center(
                child: Text(
                  'Nenhuma receita encontrada.',
                  style: TextStyle(fontSize: 16, color: corTextoSecundario),
                ),
              ),
            )
          else
            ...receitasExibidas.map((receita) => _buildReceitaCard(receita)).toList(),
          if (_hasSearched) ...[
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: OutlinedButton(
                onPressed: _limparPesquisa,
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: corPrincipalEscura, width: 1.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Limpar pesquisa',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: corPrincipalEscura),
                ),
              ),
            ),
          ]
        ],
      ),
    );
  }

  Widget _buildAbaFavoritos() {
    final receitasFavoritas = _todasAsReceitas
        .where((receita) => _receitasFavoritas.contains(receita['nome']))
        .toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Meus Favoritos',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: corPrincipalEscura),
          ),
          const SizedBox(height: 4),
          const Text(
            'Suas receitas salvas para acessar rápido.',
            style: TextStyle(fontSize: 14, color: corTextoSecundario),
          ),
          const SizedBox(height: 24),
          if (receitasFavoritas.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 50),
              child: Center(
                child: Column(
                  children: [
                    Icon(Icons.heart_broken, size: 60, color: corBordaIcone),
                    SizedBox(height: 16),
                    Text(
                      'Você ainda não favoritou\nnenhuma receita.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, color: corTextoSecundario),
                    ),
                  ],
                ),
              ),
            )
          else
            ...receitasFavoritas.map((receita) => _buildReceitaCard(receita)).toList(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: corFundo,
      appBar: AppBar(
        backgroundColor: corPrincipalEscura,
        toolbarHeight: 85,
        elevation: 0,
        shape: const RoundedRectangleBorder(),
        title: Row(
          children: const [
            Text(
              'Bake & Brew',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontFamily: 'fantasy',
              ),
            ),
            SizedBox(width: 12),
            Icon(Icons.coffee, color: Colors.white, size: 28),
          ],
        ),
      ),
      body: SafeArea(
        child: _currentIndex == 0 ? _buildAbaExplorar() : _buildAbaFavoritos(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        backgroundColor: corFundo,
        selectedItemColor: corPrincipalEscura,
        unselectedItemColor: corTextoSecundario,
        elevation: 0,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Explorar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favoritos',
          ),
        ],
      ),
    );
  }
}

class TelaReceita extends StatefulWidget {
  final Map<String, dynamic> receita;
  final bool isFavoritoInicial;
  final VoidCallback onToggleFavorito;

  const TelaReceita({
    super.key,
    required this.receita,
    required this.isFavoritoInicial,
    required this.onToggleFavorito,
  });

  @override
  State<TelaReceita> createState() => _TelaReceitaState();
}

class _TelaReceitaState extends State<TelaReceita> {
  late bool _isFavorito;

  @override
  void initState() {
    super.initState();
    _isFavorito = widget.isFavoritoInicial;
  }

  void _handleToggleFavorito() {
    setState(() {
      _isFavorito = !_isFavorito;
    });
    widget.onToggleFavorito();
  }

  @override
  Widget build(BuildContext context) {
    const corFundo = Color(0xFFFBF3E8);
    const corCaixaClara = Color(0xFFE8DCC8);
    const corTextoSecundario = Color(0xFF8A6F57);
    const corPrincipalEscura = Color(0xFF3B2B24);

    final ingredientes = widget.receita['ingredientes'] as List<String>;
    final passos = widget.receita['passos'] as List<String>;

    return Scaffold(
      backgroundColor: corFundo,
      appBar: AppBar(
        backgroundColor: corPrincipalEscura,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Receita',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: Icon(
              _isFavorito ? Icons.favorite : Icons.favorite_border,
              color: _isFavorito ? Colors.red : Colors.white,
            ),
            onPressed: _handleToggleFavorito,
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                color: corCaixaClara,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: Icon(
                  widget.receita['icone'] as IconData,
                  size: 100,
                  color: corTextoSecundario.withValues(alpha: 0.5),
                ),
              ),
            ),
            const SizedBox(height: 24),

            Text(
              widget.receita['nome'] as String,
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: corPrincipalEscura),
            ),
            const SizedBox(height: 8),
            Text(
              '${widget.receita['tempo']} • ${widget.receita['nota']}',
              style: const TextStyle(fontSize: 14, color: corTextoSecundario),
            ),
            const SizedBox(height: 24),

            Row(
              children: [
                _buildInfoCard(corCaixaClara, corPrincipalEscura, corTextoSecundario, widget.receita['tempoTotal'], 'tempo total'),
                const SizedBox(width: 12),
                _buildInfoCard(corCaixaClara, corPrincipalEscura, corTextoSecundario, widget.receita['porcoes'], 'porções'),
              ],
            ),
            const SizedBox(height: 32),

            const Text(
              'Ingredientes',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: corPrincipalEscura),
            ),
            const SizedBox(height: 12),
            ...ingredientes.map((item) => Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                children: [
                  const CircleAvatar(radius: 3, backgroundColor: corPrincipalEscura),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(item, style: const TextStyle(fontSize: 15, color: corPrincipalEscura)),
                  ),
                ],
              ),
            )).toList(),
            const SizedBox(height: 32),

            const Text(
              'Modo de preparo',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: corPrincipalEscura),
            ),
            const SizedBox(height: 16),
            ...passos.asMap().entries.map((entry) {
              int idx = entry.key;
              String passo = entry.value;
              return Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 12,
                      backgroundColor: corPrincipalEscura,
                      child: Text(
                        '${idx + 1}',
                        style: const TextStyle(fontSize: 12, color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(passo, style: const TextStyle(fontSize: 15, color: corPrincipalEscura)),
                    ),
                  ],
                ),
              );
            }).toList(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(Color bgColor, Color textColor, Color subTextColor, String titulo, String subtitulo) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Text(
              titulo,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: textColor),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              subtitulo,
              style: TextStyle(fontSize: 12, color: subTextColor),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}