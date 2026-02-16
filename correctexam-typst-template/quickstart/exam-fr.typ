// ============================================================================
// CorrectExam Quickstart - Français
// ============================================================================
// Exemple minimal pour démarrer avec CorrectExam.
// Pour plus de fonctionnalités, voir les exemples complets dans examples/

// Import local pour la CI du dépôt et le développement local
#import "../lib/lib.typ": *

// Configuration du template - lang et mode sont les réglages principaux
#show: correctexam.with(lang: "fr", mode: "withid")

// Page titre
#exam-title(
  [Mathématiques - Algèbre],
  subtitle: (
    [2024-2025],
    [Tous documents autorisés],
    [Durée : 2 heures],
    [Sujet sur #total-pages() pages],
  ),
)

// Exercice valant 5 points avec titre
#exercise(5, title: [Calcul matriciel])

// Question à réponse libre avec lignes grises pour guider l'écriture
#question[Calculer le produit $A times B$.]
#answer-box(lines: 6, dot-color: gray)

#question[Donner la trace de la matrice résultante.]
#answer-box(lines: 2)

// Exercice avec QCM (questions à choix multiples)
#exercise(4, title: [QCM])

#question[Quelle est la dimension de $RR^3$ ?]
#qcm([1], [2], [3], [Infini])
