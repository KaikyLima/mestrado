import fitz  # PyMuPDF
from deep_translator import GoogleTranslator
import time  # Necessário para evitar o bloqueio de IP do Google
import re    # Necessário para limpar o espaçamento entre letras (tracking)

def traduzir_pdf_completo(arquivo_entrada, arquivo_saida, idioma_origem='en', idioma_destino='pt'):
    # 1. Abre o documento original (imagens e layout carregados na memória)
    doc = fitz.open(arquivo_entrada)
    translator = GoogleTranslator(source=idioma_origem, target=idioma_destino)
    
    total_paginas = len(doc)
    print(f"Iniciando tradução de {total_paginas} páginas. Isso levará alguns minutos...")

    for num_pagina, page in enumerate(doc):
        print(f"-> Processando página {num_pagina + 1} de {total_paginas}...")
        
        # Extrai apenas os blocos de texto
        blocks = page.get_text("blocks")
        
        for num_bloco, block in enumerate(blocks):
            text = block[4]
            bbox = block[:4] # Coordenadas: (x0, y0, x1, y1)
            
            # Só processa se for texto de verdade (ignora sujeiras de layout)
            if text.strip() and len(text.strip()) > 1:
                try:
                    # --- LIMPEZA E PREPARAÇÃO ---
                    # Remove quebras de linha no meio da frase
                    texto_limpo = text.replace('\n', ' ')
                    
                    # Remove espaços inquebráveis e hífens invisíveis
                    texto_limpo = texto_limpo.replace('\xa0', ' ').replace('\xad', '')
                    
                    # Conserta letras separadas por formatação do PDF (tracking)
                    # Ex: "F U N C T I O N A L" vira "FUNCTIONAL"
                    texto_limpo = re.sub(r'((?:[a-zA-Z]\s+){2,}[a-zA-Z])', lambda m: m.group(1).replace(' ', ''), texto_limpo)
                    
                    # Salva os caracteres especiais transformando-os em texto seguro
                    texto_limpo = texto_limpo.replace('→', '->')
                    texto_limpo = texto_limpo.replace('⇒', '=>')
                    texto_limpo = texto_limpo.replace('≤', '<=')
                    texto_limpo = texto_limpo.replace('≥', '>=')
                    texto_limpo = texto_limpo.replace('−', '-') # Sinal de menos matemático para hífen
                    
                    # --- TRADUÇÃO ---
                    traducao = translator.translate(texto_limpo)
                    
                    # --- SUBSTITUIÇÃO VISUAL ---
                    # Pinta um retângulo branco para esconder o texto em inglês
                    page.add_redact_annot(fitz.Rect(bbox), text="", fill=(1, 1, 1))
                    page.apply_redactions()
                    
                    # Ajuste dinâmico de fonte: tenta encaixar a tradução na caixa original
                    tamanho_fonte = 10
                    inseriu_com_sucesso = -1
                    caixa_limite = fitz.Rect(bbox)
                    
                    # Vai diminuindo a fonte até a tradução caber na caixa original
                    while inseriu_com_sucesso < 0 and tamanho_fonte > 3:
                        inseriu_com_sucesso = page.insert_textbox(
                            caixa_limite, 
                            traducao, 
                            fontsize=tamanho_fonte, 
                            color=(0, 0, 0),
                            align=0 # 0 = Alinhado à esquerda
                        )
                        if inseriu_com_sucesso < 0:
                            tamanho_fonte -= 1 
                    
                    # Pausa de 0.3 segundos para o Google não bloquear a sua conexão
                    time.sleep(0.3)
                            
                except Exception as e:
                    print(f"   Aviso: Pulo no bloco {num_bloco} devido a erro: {e}")

    # 2. Salva o novo documento com as imagens originais e texto traduzido
    doc.save(arquivo_saida)
    print(f"\n✅ Sucesso! O PDF traduzido foi salvo como: {arquivo_saida}")

# Execução
traduzir_pdf_completo("p1082-papenbrock.pdf", "p1082-papenbrock-ptbr.pdf")