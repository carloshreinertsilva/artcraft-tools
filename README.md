# artcraft-tools

Ferramentas gráficas da [ArtCraft](https://getartcraft.com) prontas para o
Claude Code usar em qualquer projeto, como ferramenta (servidor MCP) e como
skill (`artcraft`):

| Ferramenta | Parecida com | Para quê |
|---|---|---|
| **VectorCraft** | Illustrator / CorelDRAW | Desenho vetorial: ícones, logos, mascotes, ilustrações. Exporta SVG, PDF, PNG... |
| **PhotoCraft** | Photoshop | Edição de imagem: camadas, máscaras, ajustes, filtros, PSD, lotes |
| **FigCraft** | Figma | Telas de app e site, protótipos, templates (app, redes sociais, ícones), exporta código |
| **PdfCraft** | Acrobat | PDFs: juntar, separar, extrair páginas e texto, informações |
| **DesignCraft** | InDesign | Diagramação: panfletos, revistas, documentos de várias páginas |

Todas são de código aberto (MIT ou Apache-2.0), feitas em Rust pela equipe
ArtCraft (github.com/storytold). Este repositório guarda:

- `bin/linux-x86_64/*-cli.xz`: as ferramentas de linha de comando já
  compiladas para Linux (o ambiente de nuvem do Claude Code), comprimidas.
- `skills/artcraft/`: a skill que ensina o Claude quando e como usar cada uma.
- `install.sh`: instala as ferramentas, a skill e registra os servidores MCP.
- `sources/`: os arquivos .zip do código-fonte usados nas compilações.
- `VERSIONS.md`: versão e origem de cada ferramenta.

## Instalar numa sessão

```sh
git clone --depth 1 https://github.com/carloshreinertsilva/artcraft-tools ~/artcraft-tools
ARTCRAFT_ROOT=/home/user bash ~/artcraft-tools/install.sh
```

`ARTCRAFT_ROOT` é a pasta onde os servidores MCP podem ler e gravar arquivos
(padrão: a pasta do usuário). Na nuvem do Claude Code os projetos ficam em
`/home/user`.

Para ter em **todas as sessões**, as duas linhas acima vão no script de
configuração do ambiente (menu do ambiente na barra de título da sessão →
Editar → Setup script).

## Compilar de novo (nova versão)

Precisa de Rust 1.95+. Para cada ferramenta:

```sh
git clone --depth 1 https://github.com/storytold/vectorcraft
cd vectorcraft && cargo build --release --locked -p vectorcraft-cli
xz -9 -c target/release/vectorcraft-cli > bin/linux-x86_64/vectorcraft-cli.xz
```

(Troque `vectorcraft` por `photocraft`, `figcraft`, `pdfcraft` ou
`designcraft`.) Cada compilação leva de 5 a 15 minutos.
