import { GET, POST } from '@/app/api/{{RESOURCE_KEBAB}}/route';
import { prisma } from '@/lib/db/prisma';

// Prismaのモック
jest.mock('@/lib/db/prisma', () => ({
  prisma: {
    {{RESOURCE_LOWER}}: {
      findMany: jest.fn(),
      count: jest.fn(),
      create: jest.fn(),
    },
  },
}));

describe('/api/{{RESOURCE_KEBAB}}', () => {
  beforeEach(() => {
    jest.clearAllMocks();
  });

  describe('GET', () => {
    it('{{RESOURCE_NAME}}一覧を取得できる', async () => {
      const mock{{RESOURCE_NAME}}s = [
        { id: '1', name: 'Test 1', createdAt: new Date() },
        { id: '2', name: 'Test 2', createdAt: new Date() },
      ];

      (prisma.{{RESOURCE_LOWER}}.findMany as jest.Mock).mockResolvedValue(mock{{RESOURCE_NAME}}s);
      (prisma.{{RESOURCE_LOWER}}.count as jest.Mock).mockResolvedValue(2);

      const request = new Request('http://localhost:3000/api/{{RESOURCE_KEBAB}}?page=1&limit=20');
      const response = await GET(request);
      const data = await response.json();

      expect(response.status).toBe(200);
      expect(data.success).toBe(true);
      expect(data.data.{{RESOURCE_LOWER}}s).toHaveLength(2);
      expect(data.data.pagination).toEqual({
        page: 1,
        limit: 20,
        total: 2,
        totalPages: 1,
      });
    });

    it('エラー時に500を返す', async () => {
      (prisma.{{RESOURCE_LOWER}}.findMany as jest.Mock).mockRejectedValue(new Error('DB Error'));

      const request = new Request('http://localhost:3000/api/{{RESOURCE_KEBAB}}');
      const response = await GET(request);
      const data = await response.json();

      expect(response.status).toBe(500);
      expect(data.success).toBe(false);
      expect(data.error.code).toBe('INTERNAL_ERROR');
    });
  });

  describe('POST', () => {
    it('{{RESOURCE_NAME}}を作成できる', async () => {
      const new{{RESOURCE_NAME}} = {
        name: 'New Test',
      };

      const created{{RESOURCE_NAME}} = {
        id: '1',
        ...new{{RESOURCE_NAME}},
        createdAt: new Date(),
      };

      (prisma.{{RESOURCE_LOWER}}.create as jest.Mock).mockResolvedValue(created{{RESOURCE_NAME}});

      const request = new Request('http://localhost:3000/api/{{RESOURCE_KEBAB}}', {
        method: 'POST',
        body: JSON.stringify(new{{RESOURCE_NAME}}),
      });

      const response = await POST(request);
      const data = await response.json();

      expect(response.status).toBe(201);
      expect(data.success).toBe(true);
      expect(data.data.name).toBe(new{{RESOURCE_NAME}}.name);
    });

    it('バリデーションエラー時に400を返す', async () => {
      const invalid{{RESOURCE_NAME}} = {
        name: '', // 空文字はエラー
      };

      const request = new Request('http://localhost:3000/api/{{RESOURCE_KEBAB}}', {
        method: 'POST',
        body: JSON.stringify(invalid{{RESOURCE_NAME}}),
      });

      const response = await POST(request);
      const data = await response.json();

      expect(response.status).toBe(400);
      expect(data.success).toBe(false);
      expect(data.error.code).toBe('VALIDATION_ERROR');
    });
  });
});
