(capa)




        Network layout algorithms in JavaScript
                    2018/Mar/01
    
    
        Renato Fabbri, renato.fabbri@gmail.com
    
        ICMC/USP, FAPESP (projeto 2017/05838-3)







==========================
(slide 1)

                 ~ Roteiro ~

  - Contexto
        * ICMC, GSoC/HelikarLab/UNL, histórico
  
  - Layouts em JS no ccNetviz:
        * 'graph drawing'
        * ccNetViz
        * Layouts implementados (geral)
        * Layouts implementados (aprofundamento)
        * Todo






==========================
(slide 2)

                ~ Contexto ~

    - Pesquisador associado ao ICMC, pelo
    proj 2017/05838-3 da FAPESP

    - ultimos feitos:
      * Vim: prv, aa, realcolors, tokipona
      * Meia suíte (música final da MASSA)
      * Escrito sobre Vim e TP
      * Aprofundamentos de IA
      * Entendendo cores e datavis

    - histórico: IFSC/USP, IA/UNICAMP,
    SGPR, labMacambira.sf.net, CDTL, etc



==========================
(slide 3)

             ~ Graph drawing ~

    - Llull (sec XIII)
    - 2D
    - Inteligibilidade, usabilidade,
    custo de obtenção, estética
    - critérios: cruzamento de arestas,
    área, simetria, simplicidade de aresta,
    comprimento total das arestas, etc
    - GraphViz, Gephi, Cytoscape.js, ccNetViz
    - e.g. grafos planares (Kuratowsky, Wagner),
    árvores

    OBS: só é útil se transmitir informação
    para os usuários




==========================
(slide 4)

             ~ NetViz (ccNetViz) ~

 'visualization of large-scale network graphs using WebGL'

      'lightweight (22kB minified), high performance'

    - cellcollective.org
    - ES8 (ES 2017)

    https://github.com/HelikarLab/ccNetViz 








==========================
(slide 5)

          ~ layouts implementados (geral) ~

    no link:
      https://github.com/HelikarLab/ccNetViz/tree/master/src/layout














==========================
(slide 6)

  ~ layouts implementados (aprofundamento) ~

      - Circular
      - Versinus
      - Hierarchical
      - Hive plot











==================================
(slide 7)

                  ~ Todo ~
          (GSoC)
    - talvez integrar Versinus e Hive
    com Cytoscape.js ou JSNetworkX
    - usar para achar os bugs (e.g. minha placa gráfica?)
    - melhorar layouts, revisar hierárquicos
    - resolver bugs, novas features
    - entender qual a real vantagem na velocidade de
    renderização e se o ccNetViz está otimizado
        https://github.com/ttm/networkTests
    - redmine
        http://helikarlab.org/redmine/projects/cell-collective-netviz
    - melhor apresentar para a comunidade acadêmica (artigo?)





==================================
(slide 8)



              ~ Obrigado! ~

        (perguntas, discussão, etc)

        renato.fabbri@gmail.com


