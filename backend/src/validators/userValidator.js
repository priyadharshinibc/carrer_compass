import { z } from 'zod';

const stringList = z.array(z.string().trim()).default([]);

const educationSchema = z.object({
  institutionName: z.string().trim().min(1),
  degree: z.string().trim().min(1),
  fieldOfStudy: z.string().trim().min(1),
  startYear: z.number().int(),
  endYear: z.number().int().optional().nullable(),
  isCurrentlyStudying: z.boolean().optional().default(false),
  gpa: z.number().optional().nullable(),
  description: z.string().optional().nullable(),
});

const careerGoalSchema = z.object({
  id: z.string().optional().nullable(),
  goalTitle: z.string().trim().min(1),
  description: z.string().trim().min(1),
  targetYear: z.number().int(),
  priority: z.enum(['High', 'Medium', 'Low']).optional().default('Medium'),
  requiredSkills: stringList,
  status: z.string().optional().default('Not Started'),
});

const profileSchema = z.object({
  email: z.string().email(),
  fullName: z.string().trim().min(1),
  phoneNumber: z.string().trim().optional().nullable(),
  profilePhotoUrl: z.string().trim().url().optional().nullable(),
  bio: z.string().optional().nullable(),
  dateOfBirth: z
    .string()
    .trim()
    .refine((value) => !Number.isNaN(Date.parse(value)), {
      message: 'Invalid datetime',
    })
    .optional()
    .nullable(),
  location: z.string().trim().optional().nullable(),
  skills: stringList,
  interests: stringList,
  hobbies: stringList,
  educationHistory: z.array(educationSchema).default([]),
  careerGoals: z.array(careerGoalSchema).default([]),
  preferredJobTitle: z.string().trim().optional().nullable(),
  employmentType: z.string().trim().optional().nullable(),
  preferredIndustries: stringList,
  languages: stringList,
  isProfileComplete: z.boolean().default(false),
});

export const createUserSchema = profileSchema;

export const updateUserSchema = profileSchema.partial().extend({
  email: z.string().email().optional(),
  fullName: z.string().trim().min(1).optional(),
});
