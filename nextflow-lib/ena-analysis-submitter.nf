// Same process duplicated in both pipelines due to a limitation in Nextflow
process ena_analysis_submit {
    publishDir params.OUTDIR, mode: 'copy'
    storeDir params.STOREDIR

    container 'sands0/ena-analysis-submitter:2.3'

    input:
    val(run_accession)
    val(sample_accession)
    file(output_bam)
    file(output_coverage_gz)
    file(output_annot_vcf_gz)
    file(filtered_vcf_gz)
    file(consensus_fasta_gz)
    path(projects_accounts_csv)
    val(study_accession)
    val(test_submission)
    path(config_yaml)
    val(async_flag)

    output:
    file("${run_accession}_output/${study_accession}/${run_accession}.bam")
    file("${run_accession}_output/${study_accession}/${run_accession}.coverage.gz")
    file("${run_accession}_output/${study_accession}/${run_accession}.annot.vcf.gz")
    file("${run_accession}_output/${study_accession}/${run_accession}_filtered.vcf.gz")
    file("${run_accession}_output/${study_accession}/${run_accession}_consensus.fasta.gz")
    file("${run_accession}_output/${study_accession}/${run_accession}_submissions.txt")

    script:
    """
    line="\$(grep ${study_accession} ${projects_accounts_csv})"
    webin_id="\$(echo \${line} | cut -d ',' -f 4)"
    webin_password="\$(echo \${line} | cut -d ',' -f 5)"
    async_flag=${async_flag}
    
    mkdir -p ${run_accession}_output/${study_accession}
    cp ${config_yaml} ${run_accession}_output/${study_accession}

    if [ "${study_accession}" = 'PRJEB45555' ]; then
        echo "Webin Username: \${webin_id} and Password: \${webin_password}"
        analysis_submission.py -t ${test_submission} -o ${run_accession}_output/${study_accession} -p PRJEB55825 -s ${sample_accession} -r ${run_accession} -f ${output_bam},${output_coverage_gz},${output_annot_vcf_gz} -a PATHOGEN_ANALYSIS -au \${webin_id} -ap \${webin_password} -as \${async_flag}
        analysis_submission.py -t ${test_submission} -o ${run_accession}_output/${study_accession} -p PRJEB55823 -s ${sample_accession} -r ${run_accession} -f ${filtered_vcf_gz} -a FILTERED_VARIATION -au \${webin_id} -ap \${webin_password} -as \${async_flag}
        analysis_submission.py -t ${test_submission} -o ${run_accession}_output/${study_accession} -p PRJEB55824 -s ${sample_accession} -r ${run_accession} -f ${consensus_fasta_gz} -a SEQUENCE_CONSENSUS -au \${webin_id} -ap \${webin_password} -as \${async_flag}
    else
        echo "Webin Username: \${webin_id} and Password: \${webin_password}"
        analysis_submission.py -t ${test_submission} -o ${run_accession}_output/${study_accession} -p ${study_accession} -s ${sample_accession} -r ${run_accession} -f ${output_bam},${output_coverage_gz},${output_annot_vcf_gz} -a PATHOGEN_ANALYSIS -au \${webin_id} -ap \${webin_password} -as \${async_flag}
        analysis_submission.py -t ${test_submission} -o ${run_accession}_output/${study_accession} -p ${study_accession} -s ${sample_accession} -r ${run_accession} -f ${filtered_vcf_gz} -a FILTERED_VARIATION -au \${webin_id} -ap \${webin_password} -as \${async_flag}
        analysis_submission.py -t ${test_submission} -o ${run_accession}_output/${study_accession} -p ${study_accession} -s ${sample_accession} -r ${run_accession} -f ${consensus_fasta_gz} -a SEQUENCE_CONSENSUS -au \${webin_id} -ap \${webin_password} -as \${async_flag}
    fi
    mv ${output_bam} ${output_coverage_gz} ${output_annot_vcf_gz} ${filtered_vcf_gz} ${consensus_fasta_gz} ${run_accession}_output/${study_accession}
    mv ${run_accession}_output/${study_accession}/successful_submissions.txt ${run_accession}_output/${study_accession}/${run_accession}_submissions.txt
    """
}

