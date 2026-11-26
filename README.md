# Bake & Brew — Aplicativo de Receitas

Aplicativo mobile em Flutter para descobrir receitas, pesquisar por nome, ler
ingredientes e modo de preparo e salvar favoritos. Os dados vêm da API pública
[DummyJSON Recipes](https://dummyjson.com/docs/recipes).

## Funcionalidades

| Requisito | Como foi atendido |
|-----------|-------------------|
| RF01 Tela principal | AppBar com a identidade do app, abas **Explorar** e **Favoritos** e carregamento automático das receitas na primeira abertura. |
| RF02 Listagem | Cards com nome, imagem (ícone alternativo se faltar ou falhar), tempo, nota e favorito. Lista com rolagem. |
| RF03 Pesquisa | Endpoint remoto `/recipes/search?q=`. Remove espaços externos, recusa consulta vazia e oferece o botão **Limpar pesquisa**. |
| RF04 Detalhes | Ingredientes, modo de preparo, tempos, porções, tipo de refeição, culinária e dificuldade, em tela rolável. |
| RF05 Favoritos | Adiciona/remove na sessão, sem duplicatas (indexados por `id`). Aba própria para consultar. |
| RF06 Carregamento | Indicador de progresso; botões desabilitados durante a busca. |
| RF07 Erros | Trata falha de rede, status diferente de 200 e JSON incompatível, com mensagem clara e botão **Tentar novamente**. |
| RF08 Ausência de resultados | Busca sem correspondência, erro de rede e favoritos vazios têm ícones e textos diferentes. |
| RF09 Navegação | Detalhes abrem por cima da listagem; ao voltar, o termo pesquisado, os resultados e a rolagem continuam como estavam. |

## Decisões técnicas

- **Tema padaria/cafeteria:** a API não tem categoria para isso, então a
  listagem e a pesquisa passam por um filtro no app
  (`Receita.ehPadariaCafeteria`). Entram sobremesas, bebidas (exceto drinks
  alcoólicos) e itens de forno ou pão (tags `Baking`, `Bruschetta`,
  `Spanakopita`). A pesquisa continua sendo remota; o filtro só descarta o que
  não combina com o tema.
- **Tema padaria/cafeteria:** a tela inicial mostra a categoria **Padaria & Café**,
  que junta (sem duplicatas, pelo `id`) as receitas da tag `Baking` e dos tipos de
  refeição `breakfast`, `snack`, `dessert` e `beverage`.
- **Detalhes:** a listagem e a pesquisa já retornam o objeto completo da receita
  (ingredientes e instruções), então a tela de detalhes reaproveita esse objeto
  em vez de chamar `/recipes/{id}` novamente.
- **Sem chamadas repetidas:** a primeira carga ocorre em `initState` (uma vez) e
  as abas ficam em um `IndexedStack`, então trocar de aba não refaz a busca.
- **Consultas concorrentes:** os botões ficam desabilitados durante o
  carregamento e cada requisição recebe um número; respostas antigas são
  descartadas.
- **Fonte única de verdade dos favoritos:** `FavoritosController`
  (`ChangeNotifier`) criado em `Perfil` e compartilhado com todas as telas.
- **Campos da API:** `rating`, tempos e porções são tratados como `num?`;
  `mealType` como lista; ausência de tempo **não** vira zero (o total só é
  calculado quando preparo e cozimento foram informados); porções só aparecem
  quando maiores que zero.

## Estrutura

```
lib/
├── main.dart
├── perfil.dart                  # tela principal (AppBar + abas)
├── principal.dart
├── tema.dart                    # paleta de cores
├── models/receita.dart          # modelo e parsing seguro
├── services/receita_service.dart# acesso à API e erros
├── state/favoritos_controller.dart
├── telas/
│   ├── aba_explorar.dart
│   ├── aba_favoritos.dart
│   └── tela_receita.dart
└── widgets/
    ├── estado_mensagem.dart
    ├── imagem_receita.dart
    └── receita_card.dart
```

## Dependências

- [`http`](https://pub.dev/packages/http) `^1.2.2`

No `pubspec.yaml`:

```yaml
dependencies:
  flutter:
    sdk: flutter
  http: ^1.2.2
```

## SDK

- Flutter 3.27 ou superior (Dart 3.6+), pois o projeto usa `Color.withValues`.

## Como executar

```bash
flutter pub get
flutter run
```

Em **Android release**, confirme que o `android/app/src/main/AndroidManifest.xml`
tem a permissão de internet:

```xml
<uses-permission android:name="android.permission.INTERNET"/>
```