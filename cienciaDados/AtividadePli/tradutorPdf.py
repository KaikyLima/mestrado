import fitz  # PyMuPDF
from deep_translator import GoogleTranslator
import time
import re
import unicodedata

# =========================
# TRADUZ TEXTO LONGO
# =========================
def traduzir_texto_longo(texto, tradutor, limite=4500):
    if len(texto) <= limite:
        return tradutor.translate(texto)

    partes = []
    while len(texto) > limite:
        corte = max(
            texto.rfind('. ', 0, limite),
            texto.rfind('; ', 0, limite),
            texto.rfind('] ', 0, limite)
        )
        if corte == -1:
            corte = texto.rfind(' ', 0, limite)
        if corte == -1:
            corte = limite

        partes.append(texto[:corte+1])
        texto = texto[corte+1:].strip()

    if texto:
        partes.append(texto)

    traduzidas = []
    for parte in partes:
        if parte.strip():
            try:
                res = tradutor.translate(parte)
                if res:
                    traduzidas.append(res)
                time.sleep(0.3)
            except Exception as e:
                print(f"Erro ao traduzir: {e}")

    return ' '.join(traduzidas)


# =========================
# LIMPEZA DE TEXTO (O DESTRUIDOR DE SETAS)
# =========================
def limpar_texto(text):
    texto = text.replace('\n', ' ')
    texto = texto.replace('\xa0', ' ').replace('\xad', '')

    texto = unicodedata.normalize("NFKC", texto)
    texto = re.sub(r'[\x00-\x1F]+', '', texto)
    texto = re.sub(r'\?{2,}', '', texto)

    texto = texto.replace('↦', ' ') 
    
    texto = re.sub(r'([a-zA-ZÀ-ÿ]{2,})\s*→\s*([a-zA-ZÀ-ÿ]{2,})', r'\1 \2', texto)
    texto = re.sub(r'([a-zà-ÿ])\s*→\s*([a-zA-ZÀ-ÿ])', r'\1 \2', texto)
    texto = re.sub(r'([a-zA-ZÀ-ÿ])\s*→\s*([a-zà-ÿ])', r'\1 \2', texto)

    texto = re.sub(r'\s+', ' ', texto).strip()

    return texto


# =========================
# PROTEGER MATEMÁTICA
# =========================
def proteger_matematica(texto):
    padrao = r'([A-Za-z0-9_\[\]\(\)]+(?:\s*[⊆⊂⊇⊃∈∉=≠→←↔\\∪∩≤≥×÷±∓≈≡∝∼]\s*[A-Za-z0-9_\[\]\(\)]+)+)'
    encontrados = re.findall(padrao, texto)
    
    mapa = {}
    for i, expr in enumerate(encontrados):
        chave = f"__MATH_{i}__"
        mapa[chave] = expr
        texto = texto.replace(expr, chave)
    
    return texto, mapa


# =========================
# RESTAURAR MATEMÁTICA (DESTAQUE COM UNDERSCORE)
# =========================
def restaurar_matematica(texto, mapa):
    for chave, valor in mapa.items():
        texto = texto.replace(chave, valor)
        
    # Símbolos complexos recebem ' _ ' para se destacarem no meio do texto normal
    conversao_ascii = {
        '⊆': ' _subconjunto_de_ ',
        '⊂': ' _contido_em_ ',
        '⊇': ' _contem_ ',
        '⊃': ' _superconj_de_ ',
        '∈': ' _pertence_a_ ',           
        '∉': ' _nao_pertence_ ',
        '≠': ' != ',
        '→': ' -> ',
        '←': ' <- ',
        '↔': ' <-> ',
        '∪': ' _uniao_ ',           
        '∩': ' _intersec_ ',
        '∅': ' _vazio_ ',
        '≤': ' <= ',
        '≥': ' >= ',
        '×': ' * ',
        '÷': ' / ',
        '−': '-',             
        '≈': ' _aprox_ ',
        '≡': ' _equiv_ ',
        'α': ' _alfa_ ', 'β': ' _beta_ ', 'γ': ' _gama_ ', 'δ': ' _delta_ ', 'Δ': ' _Delta_ ',
        'ε': ' _epsilon_ ', 'ζ': ' _zeta_ ', 'η': ' _eta_ ', 'θ': ' _teta_ ', 'Θ': ' _Theta_ ',
        'λ': ' _lambda_ ', 'Λ': ' _Lambda_ ', 'μ': ' _mi_ ', 'π': ' _pi_ ', 'Σ': ' _Sigma_ ',
        'φ': ' _fi_ ', 'ω': ' _omega_ ', 'Ω': ' _Omega_ '
    }

    for simbolo, substituto in conversao_ascii.items():
        texto = texto.replace(simbolo, substituto)

    return texto


# =========================
# FUNÇÃO PRINCIPAL
# =========================
def traduzir_artigo_academico(arquivo_entrada, arquivo_saida, idioma_origem='en', idioma_destino='pt'):
    doc = fitz.open(arquivo_entrada)
    translator = GoogleTranslator(source=idioma_origem, target=idioma_destino)

    total_paginas = len(doc)
    print(f"Iniciando tradução de {total_paginas} páginas...")

    for num_pagina in range(total_paginas):
        page = doc[num_pagina]
        print(f"-> Página {num_pagina + 1}/{total_paginas}")
        blocks = page.get_text("blocks")

        for num_bloco, block in enumerate(blocks):
            if len(block) >= 7 and block[6] != 0:
                continue 

            text = block[4]
            bbox = block[:4]

            if text.strip() and len(text.strip()) > 1:

                texto_minusculo = text.lower()

                if any(s in text for s in ['==', '!=', '++', '();', '};']):
                    continue

                if re.search(r'^(input|output|data|result|require|ensure):', texto_minusculo, re.MULTILINE):
                    continue
                    
                linhas = text.strip().split('\n')
                if len(linhas) > 3 and (sum(len(l.strip()) for l in linhas) / len(linhas)) < 25:
                    continue

                try:
                    # Captura indentação inicial
                    espacos_iniciais = len(text) - len(text.lstrip(' \t'))
                    prefixo = " " * espacos_iniciais

                    texto_limpo = limpar_texto(text)
                    texto_protegido, mapa = proteger_matematica(texto_limpo)
                    traducao = traduzir_texto_longo(texto_protegido, translator)

                    if not traducao:
                        continue

                    traducao = restaurar_matematica(traducao, mapa)
                    traducao = prefixo + traducao

                    page.add_redact_annot(fitz.Rect(bbox))
                    page.apply_redactions(images=fitz.PDF_REDACT_IMAGE_NONE)

                    tamanho_fonte = 10
                    caixa = fitz.Rect(bbox[0], bbox[1], bbox[2], bbox[3] + 5)

                    inseriu_com_sucesso = -1
                    while inseriu_com_sucesso < 0 and tamanho_fonte > 2:
                        inseriu_com_sucesso = page.insert_textbox(
                            caixa,
                            traducao,
                            fontsize=tamanho_fonte,
                            fontname="helv", # Retornado para Normal (Helvetica)
                            color=(0, 0, 0),
                            align=3 # Retornado para Justificado (Alinhamento de artigo)
                        )
                        if inseriu_com_sucesso < 0:
                            tamanho_fonte -= 1

                    if inseriu_com_sucesso < 0:
                        caixa_expandida = fitz.Rect(bbox[0], bbox[1], bbox[2] + 10, bbox[3] + 25)
                        page.insert_textbox(caixa_expandida, traducao, fontsize=4, fontname="helv", color=(0, 0, 0), align=3)

                    time.sleep(0.3)

                except Exception as e:
                    print(f"Erro no bloco {num_bloco}: {e}")

    # ==========================================
    # CRIAÇÃO DA PÁGINA INICIAL (CAPA)
    # ==========================================
    print("\n-> Gerando página inicial...")
    capa = doc.new_page(pno=0) 
    
    texto_capa = (
        "TRADUÇÃO ACADÊMICA AUTOMATIZADA\n\n\n"
        "NOTA TÉCNICA SOBRE A TRADUÇÃO DE SÍMBOLOS MATEMÁTICOS:\n\n"
        "Este documento foi traduzido automaticamente de seu idioma original. "
        "Para preservar a integridade científica da pesquisa, todos os símbolos matemáticos "
        "e notações de teoria dos conjuntos foram submetidos a um tratamento computacional especial.\n\n"
        "Antes da tradução, esses caracteres foram isolados através de tokens para evitar que "
        "fossem corrompidos. Após a tradução do texto base, os símbolos complexos foram convertidos "
        "para equivalentes textuais e destacados visualmente com sublinhados (_) para fácil "
        "identificação no meio do parágrafo (ex: o símbolo de pertinência foi transformado em '_pertence_a_').\n\n"
        "Isso garante que as equações e lógicas de algoritmos ao longo do texto permaneçam "
        "legíveis, respeitem o alinhamento das colunas e sejam precisas para o estudo acadêmico."
    )
    
    retangulo_capa = fitz.Rect(50, 100, 545, 800)
    capa.insert_textbox(retangulo_capa, texto_capa, fontsize=14, fontname="helv", color=(0.1, 0.1, 0.4), align=0)

    doc.save(arquivo_saida)
    print(f"\n✅ Tradução concluída com sucesso: {arquivo_saida}")

# =========================
# EXECUÇÃO
# =========================
traduzir_artigo_academico("3639298.pdf", "3639298-ptbr_FINAL2.pdf")