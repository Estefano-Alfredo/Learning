#Código utilizado para gerar o PDF

import matplotlib.pyplot as plt
from reportlab.pdfgen import canvas
from reportlab.lib.pagesizes import A4

#Gerando gráfico
file = "C:\\Users\\estef\\Documents\\Git_Repositories\\Learning\\ED_2\\Lista_ABP\\output\\treeReport.txt"
altura = []
quantNo = []

with open(file, "r") as treeReport:
    next(treeReport)
    for line in treeReport:
        values = line.strip().split(",")
        quantNo.append(int(values[0]))
        altura.append(int(values[1]))

plt.plot(quantNo, altura)
plt.xlabel("Quantidade de Nós")
plt.ylabel("Altura da árvore")
plt.title("Altura em relação à quantidade de nós")
plt.grid(True)
plt.savefig("grafico_altura_no.png")

#Gerando pdf relatório com o gráfico e discussão sobre o tema

nome_pdf = "5.pdf"
titulo_pdf = "Discussão Sobre Velocidade da Árvore em relação à Busca Binária"
corpo_pdf = """Durante o desenvolvimento do exercício 5 foi possível notar que sem um tratamento a árvore sempre irá 
degenerar, como pode ser observado no gráfico acima, isso começa a ocorrer perto dos trinta e cinco mil nós onde é visto um 
súbito crescimento na altura da árvore. Esse aumento torna a árvore mais lenta do que uma busca binária e um vetor ordenado,
visto que a velocidade da árvore está em algo do tipo O(n) e a velocidade da busca está em O(log n)."""

largura, altura = A4
pdf = canvas.Canvas("5.pdf", pagesize=A4)

pdf.setFont("Times-Bold", 16)
pdf.drawCentredString(largura/2, altura-85.04, titulo_pdf)
pdf.drawImage("grafico_altura_no.png", 50, 400, width=500, height=300)

pdf.setFont("Times-Roman", 12)
pdf.drawString(50, 350, "    Durante o desenvolvimento do exercício 5 foi possível notar que sem um tratamento a árvore")
pdf.drawString(50, 335, "sempre irá degenerar, como pode ser observado no gráfico acima, isso começa a ocorrer perto")
pdf.drawString(50, 320, "dos trinta e cinco mil nós onde é visto um súbito crescimento na altura da árvore. Esse aumento")
pdf.drawString(50, 305, "torna a árvore mais lenta do que uma busca binária e um vetor ordenado,visto que a velocidade da")
pdf.drawString(50, 290, "árvore está em algo do tipo O(n) e a velocidade da busca está em O(log n).")

pdf.save()