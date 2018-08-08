IF OBJECT_ID('dbo.vwKeywords', 'V') IS NOT NULL
    DROP VIEW dbo.vwKeywords;
GO

CREATE VIEW vwKeywords
AS


SELECT value = 'Cancer' UNION
SELECT value = 'Chemotherapy' UNION
SELECT value = 'Biochemistry' UNION
SELECT value = 'Genetics' UNION
SELECT value = 'Liver' UNION
SELECT value = 'Lung' UNION
SELECT value = 'Colorectal' UNION
SELECT value = 'Brain' UNION
SELECT value = 'Pancreas' UNION
SELECT value = 'Liver' UNION
SELECT value = 'Kidney' UNION
SELECT value = 'Ovarian' UNION
SELECT value = 'Prostate' UNION
SELECT value = 'Breast' UNION
SELECT value = 'Melanoma' UNION
SELECT value = 'Myeloma' UNION
SELECT value = 'Lymphoma' UNION
SELECT value = 'Leukemia' UNION
SELECT value = 'Li-Fraumeni' UNION
SELECT value = 'Genomics' UNION
SELECT value = 'Bioinformatics' UNION
SELECT value = 'Epigenomics' UNION
SELECT value = 'Metabolomics' UNION
SELECT value = 'Economics' UNION
SELECT value = 'Theranostics' UNION
SELECT value = 'Metastatic' UNION
SELECT value = 'Microarray' UNION
SELECT value = 'Tissue Banking' UNION
SELECT value = 'Screening' UNION
SELECT value = 'Early Detection' UNION
SELECT value = 'Retinoblastoma' UNION
SELECT value = 'Immunotherapy' UNION
SELECT value = 'AML' UNION
SELECT value = 'Clincal Trials' UNION
SELECT value = 'Antibodies' UNION
SELECT value = 'Oral' UNION
SELECT value = 'Nanoparticles' UNION
SELECT value = 'Treatment Failure' UNION
SELECT value = 'Oncolytic Viruses' UNION
SELECT value = 'Stem Cells' UNION
SELECT value = 'Hypoxia' UNION
SELECT value = 'MRI' UNION
SELECT value = 'CT Scans' UNION
SELECT value = 'Precision Medicine' UNION
SELECT value = 'Personalized Medicine'
