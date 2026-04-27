import pool from '../db/pool.js';

function toJson(value) {
  return value == null ? null : JSON.stringify(value);
}

function parseJson(value) {
  if (value == null) return [];
  if (Array.isArray(value)) return value;
  if (typeof value === 'string') {
    try {
      return JSON.parse(value);
    } catch {
      return [];
    }
  }
  return value;
}

function mapRow(row) {
  if (!row) return null;

  return {
    id: row.id,
    email: row.email,
    fullName: row.full_name,
    phoneNumber: row.phone_number,
    profilePhotoUrl: row.profile_photo_url,
    bio: row.bio,
    dateOfBirth: row.date_of_birth ? new Date(row.date_of_birth).toISOString() : null,
    location: row.location,
    skills: parseJson(row.skills),
    interests: parseJson(row.interests),
    hobbies: parseJson(row.hobbies),
    educationHistory: parseJson(row.education_history),
    careerGoals: parseJson(row.career_goals),
    preferredJobTitle: row.preferred_job_title,
    employmentType: row.employment_type,
    preferredIndustries: parseJson(row.preferred_industries),
    languages: parseJson(row.languages),
    isProfileComplete: Boolean(row.is_profile_complete),
    createdAt: row.created_at ? new Date(row.created_at).toISOString() : null,
    updatedAt: row.updated_at ? new Date(row.updated_at).toISOString() : null,
  };
}

function toDbPayload(profile) {
  return {
    email: profile.email,
    full_name: profile.fullName,
    phone_number: profile.phoneNumber ?? null,
    profile_photo_url: profile.profilePhotoUrl ?? null,
    bio: profile.bio ?? null,
    date_of_birth: profile.dateOfBirth ? profile.dateOfBirth.slice(0, 10) : null,
    location: profile.location ?? null,
    skills: toJson(profile.skills ?? []),
    interests: toJson(profile.interests ?? []),
    hobbies: toJson(profile.hobbies ?? []),
    education_history: toJson(profile.educationHistory ?? []),
    career_goals: toJson(profile.careerGoals ?? []),
    preferred_job_title: profile.preferredJobTitle ?? null,
    employment_type: profile.employmentType ?? null,
    preferred_industries: toJson(profile.preferredIndustries ?? []),
    languages: toJson(profile.languages ?? []),
    is_profile_complete: profile.isProfileComplete ? 1 : 0,
  };
}

export async function listUsers() {
  const [rows] = await pool.query('SELECT * FROM users ORDER BY created_at DESC');
  return rows.map(mapRow);
}

export async function getUserById(id) {
  const [rows] = await pool.query('SELECT * FROM users WHERE id = ?', [id]);
  return mapRow(rows[0]);
}

export async function createUser(profile) {
  const payload = toDbPayload(profile);
  const [result] = await pool.query(
    `INSERT INTO users (
      email, full_name, phone_number, profile_photo_url, bio, date_of_birth, location,
      skills, interests, hobbies, education_history, career_goals,
      preferred_job_title, employment_type, preferred_industries, languages, is_profile_complete
    ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)`,
    [
      payload.email,
      payload.full_name,
      payload.phone_number,
      payload.profile_photo_url,
      payload.bio,
      payload.date_of_birth,
      payload.location,
      payload.skills,
      payload.interests,
      payload.hobbies,
      payload.education_history,
      payload.career_goals,
      payload.preferred_job_title,
      payload.employment_type,
      payload.preferred_industries,
      payload.languages,
      payload.is_profile_complete,
    ],
  );

  return getUserById(result.insertId);
}

export async function updateUser(id, profile) {
  const existing = await getUserById(id);
  if (!existing) return null;

  const nextProfile = {
    ...existing,
    ...profile,
    email: profile.email ?? existing.email,
    fullName: profile.fullName ?? existing.fullName,
  };

  const payload = toDbPayload(nextProfile);

  await pool.query(
    `UPDATE users SET
      email = ?, full_name = ?, phone_number = ?, profile_photo_url = ?, bio = ?, date_of_birth = ?,
      location = ?, skills = ?, interests = ?, hobbies = ?, education_history = ?, career_goals = ?,
      preferred_job_title = ?, employment_type = ?, preferred_industries = ?, languages = ?,
      is_profile_complete = ?
    WHERE id = ?`,
    [
      payload.email,
      payload.full_name,
      payload.phone_number,
      payload.profile_photo_url,
      payload.bio,
      payload.date_of_birth,
      payload.location,
      payload.skills,
      payload.interests,
      payload.hobbies,
      payload.education_history,
      payload.career_goals,
      payload.preferred_job_title,
      payload.employment_type,
      payload.preferred_industries,
      payload.languages,
      payload.is_profile_complete,
      id,
    ],
  );

  return getUserById(id);
}

export async function deleteUser(id) {
  const [result] = await pool.query('DELETE FROM users WHERE id = ?', [id]);
  return result.affectedRows > 0;
}
