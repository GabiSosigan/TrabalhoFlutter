import 'package:flutter/material.dart';
import 'package:projetoaula/models/receita.dart';
import 'package:projetoaula/services/receita_service.dart';
import 'package:projetoaula/state/favoritos_controller.dart';
import 'package:projetoaula/telas/tela_receita.dart';
import 'package:projetoaula/tema.dart';
import 'package:projetoaula/widgets/estado_mensagem.dart';
import 'package:projetoaula/widgets/receita_card.dart';

enum _Status { carregando, sucesso, erro }

class AbaExplorar extends StatefulWidget {
  const AbaExplorar({
    super.key,
    required this.service,
    required this.favoritos,
  });

  final ReceitaService service;
  final FavoritosController favoritos;

  @override
  State<AbaExplorar> createState() => _AbaExplorarState();
}

class _AbaExplorarState extends State<AbaExplorar> {
  final TextEditingController _searchController = TextEditingController();

  _Status _status = _Status.carregando;
  List<Receita> _receitas = [];
  ReceitaException? _erro;

  /// Termo da pesquisa em exibição; `null` significa listagem geral.
  String? _termoAtivo;

  /// Mensagem de validação do campo (consulta vazia).
  String? _errorMessage;

  /// Cache da listagem inicial para "Limpar pesquisa" voltar sem nova chamada.
  List<Receita>? _cacheInicial;

  /// Identifica a requisição mais recente: respostas antigas são descartadas.
  int _requisicaoAtual = 0;

  bool get _carregando => _status == _Status.carregando;

  @override
  void initState() {
    super.initState();
    _buscar();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _buscar({String? termo}) async {
    final requisicao = ++_requisicaoAtual;
    setState(() {
      _status = _Status.carregando;
      _termoAtivo = termo;
      _erro = null;
    });

    try {
      final resultado = termo == null
          ? await widget.service.listar()
          : await widget.service.pesquisar(termo);

      if (!mounted || requisicao != _requisicaoAtual) return;
      setState(() {
        _receitas = resultado;
        if (termo == null) _cacheInicial = resultado;
        _status = _Status.sucesso;
      });
    } on ReceitaException catch (erro) {
      if (!mounted || requisicao != _requisicaoAtual) return;
      setState(() {
        _erro = erro;
        _status = _Status.erro;
      });
    }
  }

  void _realizarPesquisa() {
    if (_carregando) return;
    final termo = _searchController.text.trim();

    if (termo.isEmpty) {
      setState(() => _errorMessage = 'O campo não pode estar vazio.');
      return;
    }

    FocusScope.of(context).unfocus();
    _searchController.text = termo;
    setState(() => _errorMessage = null);
    _buscar(termo: termo);
  }

  void _limparPesquisa() {
    if (_carregando) return;
    FocusScope.of(context).unfocus();
    _searchController.clear();

    if (_cacheInicial != null) {
      setState(() {
        _errorMessage = null;
        _termoAtivo = null;
        _receitas = _cacheInicial!;
        _erro = null;
        _status = _Status.sucesso;
      });
    } else {
      setState(() => _errorMessage = null);
      _buscar();
    }
  }

  void _tentarNovamente() {
    if (_carregando) return;
    _buscar(termo: _termoAtivo);
  }

  void _abrirReceita(Receita receita) {
    TelaReceita.abrir(context, receita, widget.favoritos);
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
          sliver: SliverToBoxAdapter(child: _buildCabecalho()),
        ),
        _buildConteudo(),
      ],
    );
  }

  Widget _buildCabecalho() {
    final buscando = _termoAtivo != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 2),
        TextField(
          controller: _searchController,
          textInputAction: TextInputAction.search,
          onSubmitted: (_) => _realizarPesquisa(),
          onChanged: (_) {
            if (_errorMessage != null) setState(() => _errorMessage = null);
          },
          decoration: InputDecoration(
            hintText: 'Ex: Cookies',
            hintStyle: const TextStyle(color: Cores.textoSecundario),
            prefixIcon: const Icon(Icons.search, color: Cores.textoSecundario),
            filled: true,
            fillColor: Colors.white,
            errorText: _errorMessage,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Cores.bordaIcone),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide:
              const BorderSide(color: Cores.principalEscura, width: 2),
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
            onPressed: _carregando ? null : _realizarPesquisa,
            style: ElevatedButton.styleFrom(
              backgroundColor: Cores.principalEscura,
              foregroundColor: Colors.white,
              disabledBackgroundColor: Cores.bordaIcone,
              disabledForegroundColor: Colors.white,
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
        if (buscando) ...[
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: OutlinedButton(
              onPressed: _carregando ? null : _limparPesquisa,
              style: OutlinedButton.styleFrom(
                side: const BorderSide(
                  color: Cores.principalEscura,
                  width: 1.5,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Limpar pesquisa',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Cores.principalEscura,
                ),
              ),
            ),
          ),
        ],
        const SizedBox(height: 28),
        Text(
          buscando ? 'Resultados para "$_termoAtivo"' : 'Padaria & Café',
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Cores.principalEscura,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          buscando
              ? 'Toque na receita para ver o preparo.'
              : 'Selecione uma receita para ver seu preparo.',
          style: const TextStyle(fontSize: 14, color: Cores.textoSecundario),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildConteudo() {
    switch (_status) {
      case _Status.carregando:
        return const SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 50),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(color: Cores.principalEscura),
                  SizedBox(height: 16),
                  Text(
                    'Buscando receitas...',
                    style: TextStyle(
                      fontSize: 14,
                      color: Cores.textoSecundario,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );

      case _Status.erro:
        final erro = _erro;
        return SliverToBoxAdapter(
          child: EstadoMensagem(
            icone: erro?.tipo == TipoErro.rede
                ? Icons.wifi_off
                : Icons.error_outline,
            titulo: 'Ops, algo deu errado',
            detalhe: erro?.mensagem,
            rotuloAcao: 'Tentar novamente',
            onAcao: _tentarNovamente,
          ),
        );

      case _Status.sucesso:
        if (_receitas.isEmpty) {
          return SliverToBoxAdapter(
            child: EstadoMensagem(
              icone: Icons.search_off,
              titulo: 'Nenhuma receita encontrada.',
              detalhe: _termoAtivo == null
                  ? 'Não há receitas para mostrar no momento.'
                  : 'Não encontramos nada para "$_termoAtivo". '
                  'Confira a grafia ou tente outro nome.',
            ),
          );
        }
        return SliverPadding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          sliver: SliverList.builder(
            itemCount: _receitas.length,
            itemBuilder: (context, index) {
              final receita = _receitas[index];
              return ReceitaCard(
                key: ValueKey(receita.id),
                receita: receita,
                favoritos: widget.favoritos,
                onTap: () => _abrirReceita(receita),
              );
            },
          ),
        );
    }
  }
}