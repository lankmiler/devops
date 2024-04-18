{{/*
Expand the name of the chart.
*/}}
{{- define "name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "hostname" -}}
{{- if .Values.hostnameOverride }}
{{- .Values.hostnameOverride }}
{{- else -}}
account.{{- required "Base hostname required" .Values.global.hostnameBase -}}
{{- end }}
{{- end }}

{{- define "hostnameAlias" -}}
{{- if .Values.global.hostnameAlias -}}
account.{{- .Values.global.hostnameAlias}}
{{- else -}}
{{- include "hostname" . -}}
{{- end }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "labels" -}}
helm.sh/chart: {{ include "chart" . }}
{{ include "selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "selectorLabels" -}}
app.kubernetes.io/name: {{ include "name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{- define "vendorBinPath" -}}
{{ .Values.vendorBinPath | default "/application/vendor/bin" }}
{{- end }}

{{- define "migrations.jobname" -}}
{{- $name := include "fullname" . | trunc 55 | trimSuffix "-" -}}
{{- printf "%s-migrations" $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "setup.jobname" -}}
{{- $name := include "fullname" . | trunc 55 | trimSuffix "-" -}}
{{- printf "%s-setup" $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
