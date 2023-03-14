# covid-sequence-analysis-workflow

This is a fork of the [official repository](https://github.com/enasequence/covid-sequence-analysis-workflow) of the SARS-CoV-2 variant surveillance pipeline developed by Danish Technical University (DTU), Eotvos Lorand University (ELTE), EMBL-EBI, Erasmus Medical Center (EMC) under the [Versatile Emerging infectious disease Observatory (VEO)](https://www.globalsurveillance.eu/projects/veo-versatile-emerging-infectious-disease-observatory) project. The project consists of 20 European partners. It is funded by the European Commission.
This repository shows the interoperability of the pipeline to execute on any Cloud Provider or HPC cluster.
We will describe the use of GCP as the cloud platform in this instance.
If you need to run the pipelines on your on premise HPC cluster or on AWS, the appropriate [compute environment](https://help.tower.nf/22.4/compute-envs/google-cloud-lifesciences/) needs to be setup on Nextflow tower.

## Prerequisites

1. Have access to a Google Cloud account
2. Have a Nextflow tower account
3. Have a list of samples in a .tsv file

### Preparation

1. Follow the setup instructions as described on Nextflow tower to setup a [compute environment](https://help.tower.nf/22.4/compute-envs/google-cloud-lifesciences/) on Google
2. Follow the setup instructions as described on Nextflow tower to integrate the [codebase](https://help.tower.nf/22.4/git/overview/#github)
3. Create a project on GCP and a [Bucket](https://console.cloud.google.com/storage/browser) with the following files and folders:
	a. Folders - data,results,scratch and storeDir
	b. Files - illumina5.tsv, nanopore5.tsv, data/projects_accounts.csv, [data/NC_045512.2.fa.fai](https://github.com/sandsebi/covid-sequence-analysis-workflow/blob/3a24372fa011e7b5ed422a1a61671931f45e9866/illumina/illumina.nf#L17), [data/NC_045512.2.fa](https://github.com/sandsebi/covid-sequence-analysis-workflow/blob/3a24372fa011e7b5ed422a1a61671931f45e9866/illumina/illumina.nf#L16)

### Running pipelines via Nextflow tower

1. Setup a [new](https://tower.nf/user/sands/launchpad/new) pipeline on Nextflow tower, make sure to fill in values for the fields that have *(Required)*
2. Make sure your **Compute environment** is configured to GCP as described in the Preparation section
3. Add the URL of this reposotory in the field for **Pipeline to launch**
4. **Work directory** is a Bucket that you need to create on GCP as described in the Preparation section
5. Depending on which pipeline you want to run, add the following in the **Advanced options**:
	Nanopore - [nanopore/nanopore.nf](https://github.com/sandsebi/covid-sequence-analysis-workflow/blob/demo/nanopore/nanopore.nf)
	Illumina - [illumina/illumina.nf](https://github.com/sandsebi/covid-sequence-analysis-workflow/blob/demo/illumina/illumina.nf)
6. If you make changes to this fork make sure to enable the button to pull latest changes in the **Advanced options**
7. Click on **Add** at the bottom right corner
8. Once your pipeline is ready, make sure your sample file is uploaded on GCP and is at the location the script reads it from:
	a. For running Nanopore the samples are read from [here](https://github.com/sandsebi/covid-sequence-analysis-workflow/blob/3a24372fa011e7b5ed422a1a61671931f45e9866/nanopore/nanopore.nf#L7)
	b. For running Illumina the samples are read from [here](https://github.com/sandsebi/covid-sequence-analysis-workflow/blob/3a24372fa011e7b5ed422a1a61671931f45e9866/illumina/illumina.nf#L7)
	Make sure to change these values to point to your files and GCP account
9. After successful analysis, samples will be submitted with a test flag: https://github.com/sandsebi/covid-sequence-analysis-workflow/blob/3a24372fa011e7b5ed422a1a61671931f45e9866/nanopore/nanopore.nf#L12 to the account: https://github.com/sandsebi/covid-sequence-analysis-workflow/blob/3a24372fa011e7b5ed422a1a61671931f45e9866/illumina/illumina.nf#L18 matching the study: https://github.com/sandsebi/covid-sequence-analysis-workflow/blob/3a24372fa011e7b5ed422a1a61671931f45e9866/nanopore/nanopore.nf#L11. Since the test flag is set to true, the samples will be deleted at the end of the day.
10. Analysis results can also be seen in the results: https://github.com/sandsebi/covid-sequence-analysis-workflow/blob/3a24372fa011e7b5ed422a1a61671931f45e9866/illumina/illumina.nf#L9 folder on GCP
