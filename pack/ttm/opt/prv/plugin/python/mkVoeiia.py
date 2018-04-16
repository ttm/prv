import percolation as p

owl =  p.rdf.NS.owl
xsd =  p.rdf.NS.xsd
o = p.rdf.NS.voeiia # Vocab e Ont de Eng. de Inf. e Int. Art.
a =  p.rdf.NS.rdf.type

triples = [
        (o.EI, o.subjectMatter, o.SI),
        (o.SI, o.subjectMatter, o.I),
        (o.SI, o.subjectMatter, o.S),
        (o.IA, o.subjectMatter, o.AI),
        (o.AI, o.input, o.I),
        (o.AI, o.output, o.I),
        (o.AI, owl.subClassOf, o.SI),
        ]

terms = {
        "EI" : "Information Engineering",
        "SI" : "Information System",
        'I' : 'Information',
        'S' : 'System',
        'IA' : 'Artificial Intelligence',
        'AI' : 'Intelligent Agent'
        }

o = p.rdf.publishing.Ontology(triples, {"owl": owl, "voeiia": o}, terms)
import os
path = os.path.dirname(os.path.abspath(__file__))
o.render(path, "voeiia")





