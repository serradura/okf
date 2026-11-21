<p align="center">
  <a href="https://okfgem.com">
    <picture>
      <source media="(prefers-color-scheme: dark)" srcset=".github/hero-dark.png">
      <img src=".github/hero-light.png" width="100%" alt="okf: um lugar para o raciocínio do seu projeto viver entre as sessões do agente. Todo o OKF em um ecossistema: escreva, cure e consuma o conhecimento do seu projeto, com o seu agente. 100% local. Comece em https://okfgem.com/#try. As peças, de cima para baixo: a Agent Skill (o cérebro) escreve, cura e consome, e grava o bundle (a memória) — Markdown + YAML, no seu repositório. O bundle é lido pela biblioteca (a espinha), e por mais nada: require okf, a única coisa que toca o disco. Cinco superfícies ficam sobre ela — a CLI (o músculo) para validate, lint e search; o Grafo (a visão), ao vivo ou estático; MCP (o nervo), qualquer host, 14 ferramentas; a TUI (as mãos), seis visões sobre qualquer bundle; e o Pro (o guarda), três portas, todas fechadas. Disponível no RubyGems, como imagem Docker e como plugin do Claude Code, falando OKF v0.2.">
    </picture>
  </a>
</p>

<p align="center">
  <a href="https://rubygems.org/gems/okf"><img src="https://img.shields.io/gem/v/okf" alt="Versão da gem"></a>
  <a href="https://rubygems.org/gems/okf"><img src="https://img.shields.io/gem/dt/okf" alt="Downloads"></a>
  <a href="https://github.com/serradura/okf/pkgs/container/okf"><img src="https://img.shields.io/badge/ghcr.io-okf-2496ED?logo=docker&logoColor=white" alt="Imagem Docker"></a>
  <a href="https://github.com/serradura/okf/actions/workflows/main.yml"><img src="https://github.com/serradura/okf/actions/workflows/main.yml/badge.svg" alt="CI"></a>
  <a href="LICENSE.txt"><img src="https://img.shields.io/badge/license-Apache--2.0-blue" alt="Licença: Apache-2.0"></a>
  <a href="gems/okf/lib/okf/skill/reference/SPEC.md"><img src="https://img.shields.io/badge/OKF-v0.2-6E56CF" alt="OKF v0.2"></a>
  <a href="#plugin-do-claude-code"><img src="https://img.shields.io/badge/Claude%20Code-plugin-D97757" alt="Plugin do Claude Code"></a>
</p>

<p align="center">
  <b><a href="https://okfgem.com">Site</a></b> &nbsp;·&nbsp;
  <b><a href="https://okfgem.com/docs/">Documentação</a></b> &nbsp;·&nbsp;
  <b><a href="https://demo.okfgem.com">Demo ao vivo</a></b> &nbsp;·&nbsp;
  <b><a href="https://claude.okfgem.com">Plugin do Claude</a></b> &nbsp;·&nbsp;
  <b><a href="https://docker.okfgem.com">Imagem Docker</a></b>
</p>

<p align="center">
  <b>Português (Brasil)</b> &nbsp;·&nbsp;
  <a href="README.md">English</a>
</p>

Seu agente de código descobre como o seu sistema se encaixa — por que o serviço
existe, o que a métrica de fato mede, qual linha do schema é estrutural — e então
a sessão acaba e tudo isso se perde. Na sessão seguinte ele descobre as mesmas
coisas outra vez, a partir do mesmo código, e chega a conclusões um pouco
diferentes.

**O okf dá a esse raciocínio um lugar para viver.** Arquivos Markdown simples no
seu repositório, ao lado do código que eles explicam, escritos e mantidos em dia
pelo próprio agente, não por você.

Ele não acrescenta nada à sua stack. Nenhum banco de dados, nenhum serviço,
nenhum lugar novo para guardar conhecimento — só arquivos, revisados no mesmo
pull request que o código. Se você parar de usar o okf amanhã, tudo o que ele
escreveu continua sendo Markdown que o seu time consegue ler.

### Veja em sessenta segundos

Este repositório se documenta em OKF, então você pode percorrer um bundle real
antes de instalar qualquer coisa:

```bash
gem install okf
git clone https://github.com/serradura/okf && cd okf
okf server .okf          # o ecossistema inteiro como um grafo interativo
```

Sem Ruby na máquina? A imagem publicada roda os mesmos comandos —
[docker.okfgem.com](https://docker.okfgem.com). Ou pule o clone e abra
[demo.okfgem.com](https://demo.okfgem.com).

### Por que isso não apodrece

Anotações apodrecem porque mantê-las em dia é um ato separado de fazer o
trabalho. Aqui não é:

- **Quem escreve é o agente, não você.** Uma Agent Skill vem junto com a gem, então
  a curadoria acontece dentro do trabalho, e não depois dele.
- **Desvio é build quebrado.** `okf validate` e `okf lint` retornam códigos de
  saída, então um bundle obsoleto ou malformado quebra a CI do mesmo jeito que um
  teste quebrado.
- **O agente lê só o que precisa.** `okf index` lê o mapa e `okf search` puxa o
  punhado de arquivos que a tarefa toca, então o conhecimento cresce para além da
  janela de contexto em vez de enchê-la.

### Como se compara

O conhecimento já tem vários lares perto de um agente, e cada um guarda uma coisa
diferente. Nenhum dos outros foi feito para conhecimento de time curado e
durável:

|                                  | Bundle OKF (este)                                       | `CLAUDE.md` / `AGENTS.md`     | Memória automática do agente | Wiki / Notion       |
| -------------------------------- | ------------------------------------------------------- | ----------------------------- | ---------------------------- | ------------------- |
| Guarda                           | conhecimento de time curado                             | instruções permanentes        | o que um agente captou       | docs humanos        |
| Versionado junto com o código    | ✅                                                      | ✅                            | ❌                           | ❌                  |
| Portável entre agentes           | ✅ Markdown + YAML puros                                | ⚠️ convenções por harness     | ❌ store por agente          | ⚠️ exige exportação |
| Tipado e consultável             | ✅ frontmatter + grafo                                  | ❌ prosa                      | ❌                           | ⚠️ em parte         |
| Revisado em PRs                  | ✅                                                      | ✅                            | ❌ implícito                 | ⚠️ raramente        |
| Escala além de uma janela de contexto | ✅ progressive disclosure<br>(`okf index` + `search`) | ❌ carregado inteiro          | ⚠️ em parte                  | n/a                 |
| Verificado por ferramenta        | ✅ códigos de saída para CI<br>(`okf validate` + `lint`) | ❌                            | ❌                           | ❌                  |

As duas últimas linhas são o trabalho desta gem.

[OKF][okf] é um formato aberto e neutro em relação a fornecedores (Google Cloud,
2026). Este repositório é uma implementação completa dele, distribuída como
quatro gems, uma imagem Docker e um plugin do Claude Code.

[okf]: https://cloud.google.com/blog/products/data-analytics/how-the-open-knowledge-format-can-improve-data-sharing

## Como é um bundle

Um bundle é apenas um diretório; cada conceito é um arquivo Markdown cujo caminho
é o seu id. Este repositório documenta a _si mesmo_ em OKF, então a árvore abaixo
é real:

```
.okf/
├── index.md                       # mapa de progressive disclosure (a raiz carrega okf_version)
├── log.md                         # histórico de mudanças com datas ISO, mais recente primeiro
├── overview.md
├── gems/okf-mcp.md                # um conceito = um arquivo
├── decisions/monorepo-layout.md
└── format/frontmatter.md
```

A única exigência rígida é um frontmatter YAML com um `type` não vazio; todo o
resto é opcional e tolerado quando ausente. Um conceito se lê como abaixo — este
é o `capabilities/graph-server.md` real, do próprio bundle da gem base,
`gems/okf/.okf/`, com o corpo aparado:

```markdown
---
type: Capability
title: Interactive graph server (server)
description: A self-contained HTML knowledge graph — served over HTTP as a mountable Rack app, one bundle or many behind a hub, or written to a single static file.
resource: gems/okf/lib/okf/server/app.rb
tags: [server, graph, rack, diagram]
generated:
  by: human:maintainer
  at: 2026-08-13T12:00:00Z
---

# Overview

`okf server` boots an interactive view of the [graph](../model/graph.md) …
```

O `.okf/` acima é o mapa do **ecossistema** — um conceito por gem, por item do
plugin, por skill — e cada gem carrega o seu próprio bundle ao lado do código.
Clone o repositório e rode `okf server .okf` para navegar o mapa como um grafo
interativo, ou `okf server gems/okf/.okf` para o da gem base.

### Confiança, proveniência e ciclo de vida — OKF v0.2

Conhecimento escrito continuamente por agentes levanta perguntas que um corpus
estático nunca precisou responder: quem escreveu isto, quem conferiu, ainda está
válido? O OKF v0.2 transforma essas perguntas em frontmatter — `generated` (quem
produziu o conteúdo, e quando), `verified` (quem confirmou, do que se deriva o
nível de confiança que toda superfície mostra: `unverified` ·
`machine-confirmed` · `human-reviewed`), `sources` com atribuição por afirmação
em nota de rodapé, `status` e `stale_after` — e esta gem lê tudo isso: como
[colunas do `catalog` e filtros `--status`/`--trust`](https://okfgem.com/docs/),
como o terceiro canal visual da [página do grafo](#o-grafo), e como os achados de
proveniência, atestação e migração do
[lint](https://okfgem.com/docs/cli/lint/). Toda família é opcional, e um bundle
v0.1 continua legível para sempre — dois achados do `lint` dizem exatamente o que
uma migração mudaria, e nunca reprovam você por não tê-la feito.

## O ecossistema inteiro

O conhecimento que um agente escreve morre em quatro lugares, e uma ferramenta
que conserta um deles só ganha o direito de vê-lo morrer no próximo. **Ele nunca
chega a ser escrito**, porque escrevê-lo é um ato separado de fazer o trabalho.
**Ele apodrece**, e nada avisa até alguém agir sobre uma afirmação que deixou de
ser verdade. **Ele não pode ser encontrado**, porque o corpus cresceu além da
pessoa que teria de ler tudo. E **ele fica preso** na ferramenta que o escreveu,
então a ferramenta seguinte começa do zero.

As peças abaixo são uma resposta por falha. Elas são gems separadas porque se
*instalam* separadamente, não porque sejam produtos separados: todas leem a mesma
pasta de Markdown, nenhuma é exigida por outra, e o que você perderia ao
abandonar todas elas é ferramental, nunca o conhecimento.

Uma instalação — `gem install okf` — carrega três peças:

- uma **Agent Skill**, para que o conhecimento chegue a ser escrito: o seu agente
  cura dentro do trabalho em vez de prometer redigir depois, e você segue sendo o
  editor;
- uma **CLI e biblioteca Ruby**, para você perguntar ao corpus em vez de lê-lo —
  o que tem aqui dentro, quais tipos e quais tags, o que aponta para o quê, o que
  ninguém referencia, onde aparece aquele termo que você lembra pela metade — e
  para que desvio seja um build quebrado em vez de uma sensação: `validate` e
  `lint` respondem com códigos de saída que a CI já sabe reprovar;
- um **Grafo**, para que o formato do que o time sabe seja algo que dá para olhar
  — ao vivo na sua máquina, ou um único arquivo HTML autocontido que você hospeda
  onde quiser ou entrega a alguém que nunca vai instalar nada disso.

Três gems irmãs estendem esse mesmo comando em vez de acrescentar outro:

- **`okf mcp`** ([okf-mcp](gems/okf-mcp/README.md)), para que o conhecimento não fique preso ao terminal que o escreveu: qualquer host MCP o lê sem shell e sem nada colado no contexto — quatorze ferramentas de leitura, sobre stdio ou Streamable HTTP;
- **`okf tui`** ([okf-tui](gems/okf-tui/README.md)), para que dar uma olhada custe uma tecla em vez de quatro comandos: seis visões sobre um bundle ou sobre todos os registrados, e dá para ler um enquanto busca em todos;
- **`okf pro`** ([okf-pro](gems/okf-pro/README.md)), para que a prática se sustente nos dias em que ninguém está olhando: ele escreve o repositório de conhecimento de um agente e depois se recusa a deixá-lo apodrecer, em três portas que falham fechadas.

`gem install okf-pro` e você digita `okf pro`. O empacotamento se multiplica; a
interface não, e uma gem irmã não traz um segundo binário para aprender.

### O segundo bundle não custa nada

Ninguém para em um só. O serviço que você documentou mês passado, o manual do
time, a gem que você mantém nas horas vagas — cada um é o seu próprio bundle no
seu próprio repositório, e essa é a resposta certa, não um problema de
arquivamento para arrumar depois.

Então um bundle ganha um **nome**. `okf registry set ./handbook` o torna
`@handbook`, e onde cabe um diretório cabe um `@slug`: `okf lint @handbook`, `okf
render @handbook -o graph.html`. Grupos reúnem os que você pensa junto, e `@all`
alcança todos os que você registrou — de modo que os mesmos quatro comandos
seguram o seu corpus inteiro de uma vez, e não um bundle dele:

```bash
okf search @all "rate limit"   # todos os bundles, ranqueados juntos em uma lista
okf server                     # todos eles atrás de um hub, no navegador
okf tui                        # todos eles em uma interface de terminal
okf mcp                        # todos eles, para qualquer host MCP
```

Um `.okf.json` local do projeto substitui o registry da máquina enquanto você
está dentro daquele repositório. É assim que este monorepo endereça os seus
próprios cinco bundles como `@okf-eco`, `@okf`, `@okf-mcp`, `@okf-tui` e
`@okf-pro` sem que o `~/.okf` de ninguém fique sabendo deles.

## Como as peças se encaixam

<p align="center">
  <picture>
    <source media="(prefers-color-scheme: dark)" srcset=".github/overview-dark.png">
    <img src=".github/overview-light.png" width="760" alt="As peças, de ponta a ponta: a Agent Skill (o seu agente de código escreve e cura, você segue sendo o editor) escreve e mantém o bundle, uma pasta de Markdown + YAML no seu repositório onde um conceito é um arquivo, os links entre arquivos são o grafo de conhecimento, e o frontmatter diz quem escreveu, quem conferiu e quando aquilo vence. O bundle é lido pela biblioteca — e por mais nada — (require okf), que o lê, valida e indexa, e é a única coisa que toca o disco. Duas superfícies vêm na mesma instalação, gem install okf. A CLI, para perguntar ao corpus e barrar o merge: validate (OKF legal conforme a seção 11), lint (curado e atual), search (encontre, ranqueado), index / stats / types / tags (o que tem aqui dentro), registry (bundles endereçados como @slug). O Grafo, o formato do que o time sabe: okf server (ao vivo), okf render (HTML estático que você hospeda onde quiser), OKF::Server::App (a app Rack para um bundle), OKF::Server::Hub (a app Rack para todos os bundles), e corpos não confiáveis sanitizados. Mais três chegam pela junção de plugin, cada uma a sua própria gem e sem um segundo binário. O servidor MCP (okf mcp, a gem okf-mcp): 14 ferramentas de leitura para qualquer host MCP, lê e nunca escreve, stdio ou http sem a CLI no caminho, cada resposta limitada para uma janela de contexto. A interface de terminal (okf tui, a gem okf-tui): seis visões trocadas com as teclas numéricas — bundles, browse, search, graph, health — leia um enquanto busca em todos, e o registry editado no lugar. OKF Pro (okf pro, a gem okf-pro): escreve um repositório de conhecimento inteiro, um quadro, um diário e um roadmap, sustentados em três portas — agente, commit, CI — e todas falham fechadas. A CLI roda as verificações e recupera os dados sobre os quais a Agent Skill age. 100% local, Ruby 2.4 ou mais novo, só rack, webrick e minifts como dependências, Apache-2.0.">
  </picture>
</p>

_Tudo acima do primeiro divisor é o que um `gem install okf` te dá. Tudo abaixo
dele chega pela mesma junção de plugin, uma gem por vez, e cada porta está
listada em [O que há neste repositório](#o-que-há-neste-repositório)._

> [!TIP]
> **Navegue este repositório como conhecimento, não só como documentação.** Este
> README é a porta de entrada; a profundidade vive nos cinco bundles OKF que ele
> carrega. Comece pelo [mapa do ecossistema](.okf) — as [gems](.okf/gems/), o
> [plugin](.okf/plugin/), as [skills](.okf/skills/), as
> [decisões](.okf/decisions/) e o [próprio formato](.okf/format/) — e então abra
> o bundle de uma gem para o código dela:
> [`gems/okf/.okf/`](gems/okf/.okf). Rode `okf server .okf` para percorrer o mapa
> como um grafo interativo, ou `okf search @all <termo>` para alcançar todos os
> bundles de uma vez.

**Ele instala no Ruby que o seu sistema operacional já traz** — todo Ruby desde o
2.4, três dependências pequenas, nenhuma extensão nativa e nenhuma etapa de build
— então não há nada a provisionar e nada a manter atualizado. As
[restrições de design](gems/okf/.okf/design/) que sustentam essa linha são
verificadas por testes em todo Ruby suportado.

## O que há neste repositório

Todo nome de primeiro nível é uma fronteira, e o menu inteiro é uma linha para
cada. Um diretório sob `gems/` é uma gem, nomeada pela gem que entrega; todo o
resto na raiz é nomeado pelo que é.

| Porta | O que vive ali |
| ---- | ---------------- |
| [`gems/okf/`](gems/okf/README.md) | a gem `okf` — a agent skill, a CLI e a biblioteca, a busca ranqueada, o grafo. Tudo acima descreve esta |
| [`gems/okf-mcp/`](gems/okf-mcp/README.md) | `okf mcp` — o servidor MCP sobre o mesmo kernel: 14 ferramentas de leitura, qualquer host MCP |
| [`gems/okf-tui/`](gems/okf-tui/README.md) | `okf tui` — a interface de terminal em tela cheia, sobre um bundle ou todos os registrados |
| [`gems/okf-pro/`](gems/okf-pro/README.md) | `okf pro` — escreve o repositório de conhecimento de um agente e então o impõe em três portas |
| [`plugin/`](#plugin-do-claude-code) | o plugin do Claude Code: aquela skill, `/okf:gem` e um hook de curadoria pós-edição |
| [`.claude-plugin/`](.claude-plugin) | o manifesto do marketplace — este repositório é o seu próprio marketplace |
| [`skills/`](#a-skill-sem-a-gem) | as skills que um instalador genérico lê: `okf` e `okf-principles` |
| [`resources/`](resources/ci/github/README.md) | receitas de copiar e colar — hoje, CI que valida e faz lint dos seus bundles a cada push |
| [`.okf/`](.okf) | o mapa do ecossistema: um conceito por gem, por item do plugin, por skill — mais as decisões e o formato |
| [`.okf.json`](.okf.json) | todo bundle desta árvore, endereçável como `@slug` de qualquer lugar dela |
| [`Dockerfile`](Dockerfile) | constrói a imagem publicada a partir de `gems/okf/`, com contexto de build na raiz |
| [`.github/`](.github/workflows) | os workflows de CI, e as imagens que esta página renderiza |
| [`.claude/`](.claude/CLAUDE.md) | uma linha, apontando o Claude Code para o [`AGENTS.md`](AGENTS.md) |

## O grafo

<picture>
  <source media="(prefers-color-scheme: dark)" srcset=".github/server-dark.png">
  <img src=".github/server-light.png" alt="O servidor de grafo do okf: um grafo de conhecimento com layout dirigido por forças, com um conceito selecionado, seus vizinhos destacados e o resto do bundle esmaecido, e o painel inspetor mostrando o tipo, a descrição e as tags do conceito, e cada conceito que ele referencia e que o referencia, cada um com seu tipo.">
</picture>

_O servidor de grafo sobre o próprio bundle [`.okf`](.okf) deste repositório, com
o conceito `overview` selecionado. Experimente ao vivo em
**[demo.okfgem.com](https://demo.okfgem.com)**._

O que a página faz, e como o `okf render` assa a mesma coisa em um único arquivo
estático: [`gems/okf/README.md`](gems/okf/README.md#the-graph).

## Plugin do Claude Code

Este repositório também é um marketplace de plugins do Claude Code, então a
toolchain inteira instala com dois comandos dentro do Claude Code:

```
/plugin marketplace add serradura/okf
/plugin install okf@okfgem
```

O plugin carrega três peças: a [skill `okf`](gems/okf/README.md#the-agent-skill);
**`/okf:gem`**, uma porta de entrada que passa os argumentos à skill sem alterá-los
(sem argumentos: ela se orienta pelo seu bundle e recomenda o próximo passo, nunca
executa sozinha); e um **hook de curadoria** que roda `okf validate` + `okf lint`
depois de cada edição dentro de um bundle e devolve os achados como contexto. As
verificações são as da própria CLI, então o retorno é determinístico.

O hook fica em silêncio fora de bundles, e desligá-lo não exige configuração:
`OKF_CURATE_DISABLED=1` o desativa, `OKF_CURATE_QUIET=1` mantém os achados sem a
sugestão de instalação, e um comentário `<!-- okf-disable -->` pula um arquivo.

Prefere sem plugin? `gem install okf && okf skill .claude` instala só a skill, e a
própria skill instrui o agente a rodar as mesmas verificações depois de editar um
bundle.

## A skill, sem a gem

**Sem a gem**, qualquer agente que leia `SKILL.md` a instala direto deste
repositório:

```bash
npx skills add serradura/okf                          # escolha na lista
npx skills add serradura/okf --skill okf -a codex     # ou nomeie skill e agente
```

Esse caminho instala uma cópia gerada — o `rake skill:sync` a escreve a partir da
mesma árvore canônica que a gem entrega, e o build falha em qualquer desvio —
então ela acompanha este repositório, e não o `okf` da sua máquina. A
`okf-principles` fica ao lado dela: os cinco princípios estruturais que o formato
implica, escritos para serem apontados a qualquer artefato de instrução, e não a
um bundle.

## Estendendo o okf, e rodando com segurança

Publicar uma gem chamada `okf-*` que carregue um `okf/plugin.rb` e instalá-la é
toda a instalação: o seu verbo responde ao `okf` e se comporta como um nativo.
Nada que uma extensão registre pode substituir um verbo nativo, e uma extensão
quebrada é pulada em vez de derrubar a CLI. As três gems irmãs acima chegam
exatamente assim — `okf-mcp`, `okf-tui` e `okf-pro` entregam cada uma um
`okf/plugin.rb` e nenhum executável próprio — e nenhuma delas precisa de uma linha
da gem base para que ela saiba que existem. A sua seria a quarta, nos mesmos
termos. Contrato e modelo de ameaça:
[pontos de extensão](.okf/design/extension-points.md).

A página do grafo trata um bundle como conteúdo não confiável: os dados embutidos
são escapados, e todo corpo de conceito é sanitizado antes de chegar ao DOM, de
modo que um script escondido no Markdown é removido em vez de executado. Ela
ainda carrega bibliotecas de uma CDN, então trate um bundle desconhecido como
você trataria qualquer documento de uma fonte que não conhece. Texto completo:
[fronteira de confiança do servidor](gems/okf/.okf/design/server-trust-boundary.md).

## Desenvolvimento

Da raiz do repositório — `rake` puro, não há Gemfile na raiz:

```bash
rake              # a tarefa default de cada gem (testes + RuboCop), depois o lint no nível do repo
rake test         # a suíte de testes de cada gem
rake okf          # valida + faz lint de todo bundle .okf registrado
rake serve        # navegue o bundle deste próprio projeto como um grafo
```

Do diretório de qualquer gem, para trabalhar naquela gem — `cd gems/okf-mcp`, `cd
gems/okf-tui` ou `cd gems/okf-pro` seguem os mesmos três comandos, e cada uma tem
seu próprio README e job de CI. De `gems/okf`, para trabalhar na gem base:

```bash
cd gems/okf
bin/setup               # instala as dependências
bundle exec rake        # testes + RuboCop (o que a CI roda)
bundle exec rake test   # só a suíte de testes
ruby -Ilib exe/okf validate <dir>   # rode a CLI a partir de um checkout
```

A suíte roda em todo Ruby suportado; para conferir o piso do 2.4 localmente, da
raiz do repositório:

```bash
docker run --rm -v "$PWD":/src:ro ruby:2.4 bash -c \
  "cp -a /src /build && cd /build/gems/okf && rm -f Gemfile.lock && bundle install --quiet && bundle exec rake test"
```

A página do grafo tem a sua própria suíte em um navegador de verdade (`bundle
exec rake browser:setup`, depois `rake test:browser`, ambos a partir de
`gems/okf/`). Veja o [AGENTS.md](AGENTS.md) para o guia do mantenedor.

## Contribuindo

Relatos de bug e pull requests são bem-vindos no GitHub, em
<https://github.com/serradura/okf>. Este projeto quer ser um espaço seguro e
acolhedor para colaboração, e espera-se que quem contribui siga o
[código de conduta](CODE_OF_CONDUCT.md).

## Licença

A gem está disponível como código aberto sob os termos da
[Licença Apache 2.0](https://www.apache.org/licenses/LICENSE-2.0) (veja
`LICENSE.txt`). A especificação do Open Knowledge Format que acompanha a skill é
de autoria do Google Cloud Platform e está incluída sob a sua própria licença
Apache-2.0, Copyright (c) Google LLC. Veja `NOTICE` e
`okf/lib/okf/skill/reference/APACHE-2.0.txt`.

O [okf-skills](https://github.com/scaccogatto/okf-skills), de Marco Boffo, um
toolkit OKF em Python para o Claude Code com uma visão de grafo interativa cheia
de recursos, foi uma inspiração inicial para o plugin do Claude Code desta gem e
para a comparação de conhecimento-como-código em
[Como se compara](#como-se-compara). O okf toma outra forma: uma gem nativa de
Ruby construída em torno da CLI `okf` e de uma biblioteca embutível.
