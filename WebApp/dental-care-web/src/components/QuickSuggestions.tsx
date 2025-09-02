import { Box, Chip } from "@mui/material";

interface QuickSuggestionsProps {
  onSelect: (msg: string) => void;
}

const suggestions = [
  "How to prevent cavities?",
  "What causes gum disease?",
  "How do I whiten teeth?",
  "What to do for toothache?",
];

export default function QuickSuggestions({ onSelect }: QuickSuggestionsProps) {
  return (
    <Box display="flex" gap={1} flexWrap="wrap" p={1}>
      {suggestions.map((s, i) => (
        <Chip
          key={i}
          label={s}
          clickable
          color="primary"
          variant="outlined"
          onClick={() => onSelect(s)}
        />
      ))}
    </Box>
  );
}
