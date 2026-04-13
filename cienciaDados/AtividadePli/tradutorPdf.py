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
# LIMPEZA DE TEXTO
# =========================
def limpar_texto(text):
    texto = text.replace('\n', ' ')
    texto = texto.replace('\xa0', ' ').replace('\xad', '')

    # mantém símbolos matemáticos
    texto = unicodedata.normalize("NFKC", texto)

    # remove caracteres de controle
    texto = re.sub(r'[\x00-\x1F]+', '', texto)

    # remove lixo tipo ????
    texto = re.sub(r'\?{2,}', '', texto)

    # remove seta bugada específica
    texto = texto.replace('↦', ' ')

    texto = re.sub(r'\s+', ' ', texto).strip()

    return texto


# =========================
# PROTEGER MATEMÁTICA
# =========================
def proteger_matematica(texto):
    padrao = r'([A-Za-z0-9_\[\]\(\)]+(?:\s*[⊆⊂⊇⊃∈∉=≠→←↔\\∪∩]\s*[A-Za-z0-9_\[\]\(\)]+)+)'
    
    encontrados = re.findall(padrao, texto)
    
    mapa = {}
    for i, expr in enumerate(encontrados):
        chave = f"__MATH_{i}__"
        mapa[chave] = expr
        texto = texto.replace(expr, chave)
    
    return texto, mapa


# =========================
# RESTAURAR MATEMÁTICA
# =========================
def restaurar_matematica(texto, mapa):
    for chave, valor in mapa.items():
        texto = texto.replace(chave, valor)
    return texto


# =========================
# FUNÇÃO PRINCIPAL
# =========================
def traduzir_artigo_academico(arquivo_entrada, arquivo_saida, idioma_origem='en', idioma_destino='pt'):
    doc = fitz.open(arquivo_entrada)
    translator = GoogleTranslator(source=idioma_origem, target=idioma_destino)

    total_paginas = len(doc)
    print(f"Iniciando tradução de {total_paginas} páginas...")

    for num_pagina, page in enumerate(doc):
        print(f"-> Página {num_pagina + 1}/{total_paginas}")
        blocks = page.get_text("blocks")

        for num_bloco, block in enumerate(blocks):
            if len(block) >= 7 and block[6] != 0:
                continue

            text = block[4]
            bbox = block[:4]

            if text.strip() and len(text.strip()) > 1:

                texto_minusculo = text.lower()

                # filtros básicos
                if any(s in text for s in ['==', '!=', '++', '();', '};']):
                    continue

                if re.search(r'^(input|output|data|result|require|ensure):',
                             texto_minusculo, re.MULTILINE):
                    continue

                try:
                    # LIMPA TEXTO
                    texto_limpo = limpar_texto(text)

                    # 🔒 PROTEGE MATEMÁTICA
                    texto_protegido, mapa = proteger_matematica(texto_limpo)

                    # 🌍 TRADUZ
                    traducao = traduzir_texto_longo(texto_protegido, translator)

                    if not traducao:
                        continue

                    # 🔓 RESTAURA MATEMÁTICA
                    traducao = restaurar_matematica(traducao, mapa)

                    # REMOVE TEXTO ORIGINAL
                    page.add_redact_annot(fitz.Rect(bbox))
                    page.apply_redactions(images=fitz.PDF_REDACT_IMAGE_NONE)

                    # INSERE TRADUÇÃO
                    tamanho_fonte = 10
                    caixa = fitz.Rect(bbox)

                    while tamanho_fonte > 3:
                        res = page.insert_textbox(
                            caixa,
                            traducao,
                            fontsize=tamanho_fonte,
                            fontname="helv"
                        )
                        if res >= 0:
                            break
                        tamanho_fonte -= 1

                    time.sleep(0.2)

                except Exception as e:
                    print(f"Erro no bloco {num_bloco}: {e}")

    doc.save(arquivo_saida)
    print(f"\n✅ Tradução concluída: {arquivo_saida}")


# =========================
# EXECUÇÃO
# =========================
traduzir_artigo_academico("3639298.pdf", "3639298-ptbr_v12.pdf")