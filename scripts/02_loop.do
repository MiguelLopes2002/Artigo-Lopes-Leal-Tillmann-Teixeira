/******************************************************************
  Execução em série — versão completa
  Salva log-lik, Wald χ² e Pseudo R²
******************************************************************/
cd "Disco:/Caminho"
*---------------------------------------------------------------*
* 1. Pastas
*---------------------------------------------------------------*
cap mkdir data
cap mkdir resultados_modelo
* A pasta "data" deve conter o arquivo "dados_regressao.dta", com a base gera- *
* da no documento de extensão .do                                              *
*---------------------------------------------------------------*
* 2. Tabela com combinações de cortes
*---------------------------------------------------------------*
clear
set obs 0

local cortes_superiores 12 24 36 48 60 72 84 96 108 120 132 144 156 168 180 ///
						192 204 216 228 240 252 264 276 288 300 312 324 336 ///
						348 360
local deslocamentos 0

gen lim_inf     = .
gen lim_sup     = .
gen str20 config_name = ""

foreach corte_sup of local cortes_superiores {
    foreach desloc1 of local deslocamentos {
        foreach desloc2 of local deslocamentos {

            set obs `=_N + 1'                          
            local lim_inf_calc = 12 + `desloc1'
            local lim_sup_calc = `corte_sup' + `desloc2'
            local config       = "corte_`lim_inf_calc'_`lim_sup_calc'"

            replace lim_inf     = `lim_inf_calc'           in `=_N'
            replace lim_sup     = `lim_sup_calc'           in `=_N'
            replace config_name = "`config'"               in `=_N'
        }
    }
}

save data/cortes_config.dta, replace

*---------------------------------------------------------------*
* 3. Template de resultado 
*---------------------------------------------------------------*
clear
input str25 config_name double loglik double wald double r2
"" . . .
end
save data/result_template.dta, replace

*---------------------------------------------------------------*
* 4. Loop principal
*---------------------------------------------------------------*
use data/cortes_config.dta, clear
local total_models = _N

forvalues i = 1/`total_models' {
    di as text "==> Modelo `i' / `total_models'"

    /* ---- lê parâmetros da i-ésima linha da tabela de cortes ---- */
    preserve
        use data/cortes_config.dta, clear
        keep if _n == `i'
        local liminf = lim_inf[1]
        local limsup = lim_sup[1]
        local config = config_name[1]
    restore

    /* ---- se resultado já existe, pula ---- */
    local outdta "resultados_modelo/resultado_`config'.dta"
    if fileexists("`outdta'") {
        di as result "   Resultado para `config' já existe – pulando"
        continue   //   vai para a próxima volta do forvalues
    }

    /* ---- base de regressão completa ---- */
    use data/dados_regressao.dta, clear
    capture drop tempo_ordinal
    gen tempo_ordinal = .
    replace tempo_ordinal = 0 if tempoemprego_clean <  `liminf'
    replace tempo_ordinal = 1 if inrange(tempoemprego_clean, `liminf', `limsup'-1)
    replace tempo_ordinal = 2 if tempoemprego_clean >= `limsup'
    label define tempo_ordinal_lbl 0 "Curto" 1 "Médio" 2 "Longo", replace
    label values tempo_ordinal tempo_ordinal_lbl

    /* ---- log & modelo com "try/catch" (capture) ---- */
    capture log close
    log using "resultados_modelo/resultados_`config'.txt", text replace

    capture noisily gologit2 tempo_ordinal ///
        i.sexotrabalhador i.estado i.raça i.escolaridade c.idade##c.idade ///
        i.cnae_agrupado i.nacionalidade i.afastamento i.tipovínculo ///
        i.porte i.horas, or autofit lrforce robust

    local rc = _rc         // 0 = convergiu; ≠0 = erro

    if `rc' == 0 {
        di "--------------------------------------------------"
        di "Pseudo R2 (e(r2_p)) = " %9.4f e(r2_p)
        di "Log-Lik  (e(ll))   = " %12.3f e(ll)
        di "Wald χ²  (e(chi2)) = " %12.3f e(chi2)
        di "--------------------------------------------------"
    }
    else {
        di as error ">>> Erro rc=`rc' em `config' – resultados gravados como missing"
    }
    log close

    /* ---- salva estatísticas (ou missing, se erro) ---- */
    preserve
        use data/result_template.dta, clear
        replace config_name = "`config'" in 1
        if `rc' == 0 {
            replace loglik = e(ll)   in 1
            replace wald   = e(chi2) in 1
            replace r2     = e(r2_p) in 1
        }
        save "`outdta'", replace
    restore
}

*---------------------------------------------------------------*
* 5. Consolida resultados
*---------------------------------------------------------------*
clear
local arquivos : dir "resultados_modelo" files "resultado_*.dta"
foreach f of local arquivos {
    append using resultados_modelo/`f'
}

save resultados_modelo/resumo_modelos.dta, replace

export excel using resultados_modelo/resumo_modelos.xlsx, ///
       firstrow(variables) replace
	   
*---------------------------------------------------------------*
* 7. Limpa temporários
*---------------------------------------------------------------*
local trash : dir "resultados_modelo" files "resultado_*.dta"
foreach f of local trash {
    erase resultados_modelo/`f'
}
erase data/result_template.dta
erase data/cortes_config.dta

*---------------------------------------------------------------*
*---------------------------------------------------------------*

