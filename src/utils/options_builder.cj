package ollama4cj.utils

import std.collection.HashMap

public class OptionsBuilder {

    private let options = Options()

    public OptionsBuilder() {
    }

    public func setMirostat(value: Int64): OptionsBuilder {
        options.optionsMap.add("mirostat", value)
        return this
    }

    public func setMirostatEta(value: Float64): OptionsBuilder {
        options.optionsMap.add("mirostat_eta", value)
        return this
    }


    public func setMirostatTau(value: Float64): OptionsBuilder {
        options.optionsMap.add("mirostat_tau", value)
        return this
    }

    public func setNumCtx(value: Int64): OptionsBuilder {
        options.optionsMap.add("num_ctx", value)
        return this
    }

    public func setNumGqa(value: Int64): OptionsBuilder {
        options.optionsMap.add("num_gqa", value)
        return this
    }

    public func setNumGpu(value: Int64): OptionsBuilder {
        options.optionsMap.add("num_gpu", value)
        return this
    }

    public func setNumThread(value: Int64): OptionsBuilder {
        options.optionsMap.add("num_thread", value)
        return this
    }

    public func setRepeatLastN(value: Int64): OptionsBuilder {
        options.optionsMap.add("repeat_last_n", value)
        return this
    }

    public func setRepeatPenalty(value: Float64): OptionsBuilder {
        options.optionsMap.add("repeat_penalty", value)
        return this
    }

    public func setTemperature(value: Float64): OptionsBuilder {
        options.optionsMap.add("temperature", value)
        return this
    }

    public func setSeed(value: Int64): OptionsBuilder {
        options.optionsMap.add("seed", value)
        return this
    }

    public func setStop(value: String): OptionsBuilder {
        options.optionsMap.add("stop", value)
        return this
    }

    public func setTfsZ(value: Float64): OptionsBuilder {
        options.optionsMap.add("tfs_z", value)
        return this
    }

    public func setNumPredict(value: Int64): OptionsBuilder {
        options.optionsMap.add("num_predict", value)
        return this
    }

    public func setTopK(value: Int64): OptionsBuilder {
        options.optionsMap.add("top_k", value)
        return this
    }

    public func setTopP(value: Float64): OptionsBuilder {
        options.optionsMap.add("top_p", value)
        return this
    }

    public func setMinP(value: Float64): OptionsBuilder {
        options.optionsMap.add("min_p", value)
        return this
    }

    public func setCustomOption(name: String, value: ToString): OptionsBuilder {
        if (!(value is Int64) && !(value is Float64) && !(value is String)) {
            throw IllegalArgumentException("Invalid type for parameter. Allowed types are: Int64, Float64, or String.")
        }
        options.optionsMap.add(name, value)
        return this
    }
 
    public func build(): Options {
        return options
    }
}