export interface Riddle {
  question: string;
  answers: string[];
  hint: string;
}

export const RIDDLE_HINT_COST = 10;

export const RIDDLES: Riddle[] = [
  {
    question: "I have keys but open no locks, I have space but no room, and you can enter but never go outside. What am I?",
    answers: ["keyboard"],
    hint: "You tap my buttons to type letters and words on a computer.",
  },
  {
    question: "The more of me you take, the more you leave behind. What am I?",
    answers: ["footsteps", "footstep"],
    hint: "Think about what you leave on the ground every time you walk somewhere.",
  },
  {
    question: "I am made of clay, I hold oil and a cotton wick, and I light up homes on Diwali night. What am I?",
    answers: ["diya", "diye", "deepak"],
    hint: "Look around your home during Diwali. I am the small glowing lamp on every doorstep.",
  },
  {
    question: "The more I dry, the wetter I become. What am I?",
    answers: ["towel"],
    hint: "You reach for me right after a bath or a shower.",
  },
  {
    question: "I have a face and two hands but no arms or legs, and I tell you the time. What am I?",
    answers: ["clock", "watch"],
    hint: "You can find me on a wall or on your wrist, ticking through the seconds.",
  },
  {
    question: "I have many rings but no fingers, and people talk into me. What am I?",
    answers: ["telephone", "phone"],
    hint: "Hold me to your ear to chat with a friend who is far away.",
  },
];

export function normalizeAnswer(value: string): string {
  return value.toLowerCase().replace(/[^a-z0-9]/g, "");
}

export function isCorrectAnswer(riddle: Riddle, attempt: string): boolean {
  const normalized = normalizeAnswer(attempt);
  return normalized.length > 0 && riddle.answers.some((a) => normalizeAnswer(a) === normalized);
}
