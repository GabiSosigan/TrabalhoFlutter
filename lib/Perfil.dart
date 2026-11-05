import 'package:flutter/material.dart';

class Perfil extends StatefulWidget {
  const Perfil({super.key});

  @override
  State<Perfil> createState() => _PerfilState();
}

class _PerfilState extends State<Perfil> {
  final TextEditingController _searchController = TextEditingController();

  String _searchedTerm = '';
  bool _hasSearched = false;
  String? _errorMessage;

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

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const corFundo = Color(0xFFFBF3E8);
    const corCaixaClara = Color(0xFFE8DCC8);
    const corBordaIcone = Color(0xFFCBBBA0);
    const corTextoSecundario = Color(0xFF8A6F57);
    const corPrincipalEscura = Color(0xFF3B2B24);

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
        child: SingleChildScrollView(
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
                _hasSearched
                    ? 'Resultados para "$_searchedTerm"'
                    : 'Receitas disponíveis',
                style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: corPrincipalEscura
                ),
              ),
              const SizedBox(height: 4),
              Text(
                _hasSearched
                    ? 'Toque na receita para ver o preparo.'
                    : 'Selecione uma receita para ver seu preparo.',
                style: const TextStyle(fontSize: 14, color: corTextoSecundario),
              ),
              const SizedBox(height: 16),

              Container(
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
                      child: const Icon(Icons.coffee, color: corTextoSecundario, size: 40),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Chocolate Quente',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: corPrincipalEscura),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            '20 min • Fácil',
                            style: TextStyle(fontSize: 12, color: corTextoSecundario),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              Text(
                                '5 / 5',
                                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: corPrincipalEscura),
                              ),
                              Icon(Icons.favorite_border, size: 20, color: corPrincipalEscura),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 15),

              // Segundo Card
              Container(
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
                      child: const Icon(Icons.emoji_food_beverage_rounded, color: corTextoSecundario, size: 40),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Matcha Latte',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: corPrincipalEscura),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            '10 min • Fácil',
                            style: TextStyle(fontSize: 12, color: corTextoSecundario),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              Text(
                                '4.0 / 5',
                                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: corPrincipalEscura),
                              ),
                              Icon(Icons.favorite_border, size: 20, color: corPrincipalEscura),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 15),

              Container(
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
                      child: const Icon(Icons.bakery_dining, color: corTextoSecundario, size: 40),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Croissant',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: corPrincipalEscura),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            '1h 20 min • Médio',
                            style: TextStyle(fontSize: 12, color: corTextoSecundario),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              Text(
                                '4.8 / 5',
                                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: corPrincipalEscura),
                              ),
                              Icon(Icons.favorite_border, size: 20, color: corPrincipalEscura),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

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
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: corPrincipalEscura
                      ),
                    ),
                  ),
                ),
              ]
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
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
            icon: Icon(Icons.favorite_border,),
            label: 'Favoritos',
          ),
        ],
      ),
    );
  }
}