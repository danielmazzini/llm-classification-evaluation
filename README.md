# LLM classification evaluation

A small .NET 10 evaluation extracted from Moderator. It runs the approved bilingual 140-case classification dataset against an Ollama model using structured output and reports exact category matches, accuracy, macro-F1 and per-case errors.

## Requirements

.NET 10 SDK, Ollama running locally, and a model that supports structured output. Install PowerShell 7 to use the comparison script.

```sh
dotnet run -- --model llama3.2 --output report.json
```

Use `--endpoint http://localhost:11434` to select the Ollama server. Compare models sequentially with:

```powershell
./Compare-Models.ps1 -Models llama3.2,qwen3:4b
```

Each run verifies the approved SHA-256 dataset hash after normalizing CRLF to LF. Reports include hashes of the dataset and instructions. Errors are included as failed cases. Macro-F1 gives equal weight to all seven categories.

This evaluates direct classification on synthetic cases. It does not reproduce Moderator's guards, API or production flow, and results should not be compared directly with historical production evaluations. One run per model does not establish statistical stability.
