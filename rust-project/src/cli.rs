use clap::Parser;

#[derive(Parser, Debug)]
#[command(author, version, about, long_about = None)]
pub struct Args {
    /// The input string to convert to uppercase
    #[arg(short, long)]
    pub input: String,
}

pub fn parse_args() -> Args {
    Args::parse()
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_args_parsing() {
        let args = Args {
            input: "test".to_string(),
        };
        assert_eq!(args.input, "test");
    }
}