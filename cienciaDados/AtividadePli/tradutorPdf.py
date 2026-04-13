import fitz  # PyMuPDF
from deep_translator import GoogleTranslator
import time
import re

def traduzir_artigo_academico(arquivo_entrada, arquivo_saida, idioma_origem='en', idioma_destino='pt'):
    # 1. Abre o documento original
    doc = fitz.open(arquivo_entrada)
    translator = GoogleTranslator(source=idioma_origem, target=idioma_destino)
    
    total_paginas = len(doc)
    print(f"Iniciando tradução avançada de {total_paginas} páginas. Isso levará alguns minutos...")

    for num_pagina, page in enumerate(doc):
        print(f"-> Processando página {num_pagina + 1} de {total_paginas}...")
        blocks = page.get_text("blocks")
        
        for num_bloco, block in enumerate(blocks):
            text = block[4]
            bbox = block[:4] # Coordenadas: (x0, y0, x1, y1)
            
            # Só processa se for texto de verdade (ignora sujeiras de layout)
            if text.strip() and len(text.strip()) > 1:
                try:
                    # --- 1. LIMPEZA ESTRUTURAL ---
                    # Remove quebras de linha no meio da frase
                    texto_limpo = text.replace('\n', ' ')
                    
                    # Remove espaços inquebráveis e hífens invisíveis
                    texto_limpo = texto_limpo.replace('\xa0', ' ').replace('\xad', '')
                    
                    # Conserta o tracking (espaçamento forçado de letras em títulos do LaTeX)
                    # Ex: "F U N C T I O N A L" vira "FUNCTIONAL"
                    texto_limpo = re.sub(r'((?:[a-zA-Z]\s+){2,}[a-zA-Z])', lambda m: m.group(1).replace(' ', ''), texto_limpo)
                    
                    # --- 2. PROTEÇÃO MATEMÁTICA ANTES DA TRADUÇÃO ---
                    # Substitui caracteres Unicode difíceis por equivalentes textuais provisórios
                    mapa_matematico = {
                        '→': ' -> ', '⇒': ' => ', '≤': ' <= ', '≥': ' >= ', '−': '-',
                        'π': ' pi ', '∈': ' IN ', '∉': ' NOT_IN ', '∧': ' AND ', '∪': ' UNION ',
                        '∩': ' INT ', '⊆': ' SUBSET ', '⊂': ' STRICT_SUBSET ', 'ˆ': '^', '∅': ' VAZIO '
                    }
                    for simbolo, substituto in mapa_matematico.items():
                        texto_limpo = texto_limpo.replace(simbolo, substituto)
                    
                    # --- 3. TRADUÇÃO ---
                    traducao = translator.translate(texto_limpo)
                    
                    # --- 4. RESTAURAÇÃO MATEMÁTICA PÓS-TRADUÇÃO ---
                    # Volta os equivalentes textuais para símbolos que a fonte padrão suporte bem
                    mapa_restauracao = {
                        ' -> ': ' -> ', ' => ': ' => ', ' IN ': ' e ', ' NOT_IN ': ' nao_e ',
                        ' AND ': ' ^ ', ' INT ': ' intersec ', ' SUBSET ': ' contido_em ',
                        ' VAZIO ': ' vazio ', ' pi ': ' pi '
                    }
                    for texto_prov, simbolo_real in mapa_restauracao.items():
                        # Usamos case-insensitive (re.IGNORECASE) porque o tradutor pode mudar maiúsculas/minúsculas
                        traducao = re.sub(texto_prov, simbolo_real, traducao, flags=re.IGNORECASE)

                    # --- 5. INSERÇÃO NO PDF ---
                    # Pinta um retângulo branco para esconder o texto em inglês
                    page.add_redact_annot(fitz.Rect(bbox), text="", fill=(1, 1, 1))
                    page.apply_redactions()
                    
                    tamanho_fonte = 10
                    inseriu_com_sucesso = -1
                    caixa_limite = fitz.Rect(bbox)
                    
                    # Vai diminuindo a fonte até a tradução caber na caixa original
                    while inseriu_com_sucesso < 0 and tamanho_fonte > 4:
                        inseriu_com_sucesso = page.insert_textbox(
                            caixa_limite, 
                            traducao, 
                            fontsize=tamanho_fonte, 
                            fontname="tiro", # Usa Times-Roman (Fonte Serifada Acadêmica) nativa do PDF
                            color=(0, 0, 0),
                            align=0 # 0 = Alinhado à esquerda
                        )
                        if inseriu_com_sucesso < 0:
                            tamanho_fonte -= 1 
                            
                    # Pausa de 0.3 segundos para o Google não bloquear a sua conexão
                    time.sleep(0.3)
                            
                except Exception as e:
                    print(f"   Aviso: Pulo no bloco {num_bloco} devido a erro: {e}")

    # Salva o novo documento com as imagens originais e texto traduzido
    doc.save(arquivo_saida)
    print(f"\n✅ Sucesso! O PDF traduzido com layout acadêmico foi salvo como: {arquivo_saida}")

# Execução
traduzir_artigo_academico("p1082-papenbrock.pdf", "p1082-papenbrock-ptbr.pdf")